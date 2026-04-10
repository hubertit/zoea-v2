import { Injectable, Logger } from '@nestjs/common';
import OpenAI from 'openai';
import { IntegrationsService } from '../integrations/integrations.service';
import { ContentSearchService, SearchResult } from './content-search.service';
import { resolveOpenAiChatModel } from './openai-model.util';

interface OpenAIConfig {
  // Some deployments store the key as `apiKey`, others as `api_key`.
  // We support both for backward compatibility.
  apiKey?: string;
  api_key?: string;
  model?: string;
  maxTokens?: number;
  temperature?: number;
}

interface ChatMessage {
  role: 'user' | 'assistant' | 'system';
  content: string;
}

interface ChatResponse {
  text: string;
  cards: SearchResult[];
  suggestions: string[];
}

@Injectable()
export class OpenAIService {
  private readonly logger = new Logger(OpenAIService.name);
  private openai: OpenAI | null = null;
  // Keep this low to avoid upstream gateway 504s when outbound network is flaky.
  private readonly openaiRequestTimeoutMs = 8000;

  constructor(
    private integrationsService: IntegrationsService,
    private contentSearchService: ContentSearchService,
  ) {
    this.initializeOpenAI();
  }

  private async initializeOpenAI() {
    try {
      const integration = await this.integrationsService.findByName('openai').catch(() => null);
      if (!integration) {
        this.logger.warn("Integration 'openai' not found - assistant will not work");
        return;
      }

      if (!integration.isActive) {
        this.logger.warn("Integration 'openai' is inactive - assistant will not work");
        return;
      }

      const config = integration.config as OpenAIConfig | null;
      const apiKeyRaw = (config as any)?.apiKey ?? (config as any)?.api_key;
      const apiKey = typeof apiKeyRaw === 'string' ? apiKeyRaw.trim() : '';

      if (apiKey) {
        this.openai = new OpenAI({ apiKey });
        this.logger.log('OpenAI initialized successfully');
        return;
      }

      this.logger.warn(
        "OpenAI not configured - integration 'openai' has an empty api key",
      );
    } catch (error) {
      this.logger.error('Failed to initialize OpenAI', error);
    }
  }

  /**
   * Main chat method - handles user message and returns assistant response
   */
  async chat(
    userMessage: string,
    conversationHistory: ChatMessage[] = [],
    location?: { lat: number; lng: number },
    countryCode?: string,
  ): Promise<ChatResponse> {
    if (!this.openai) {
      await this.initializeOpenAI();
      if (!this.openai) {
        // Don't crash the whole API when OpenAI isn't configured.
        // Return a friendly fallback so conversation history can still work.
        return {
          text: 'AI assistant is temporarily unavailable. Please try again later.',
          cards: [],
          suggestions: [],
        };
      }
    }

    const config = await this.integrationsService.getConfig<OpenAIConfig>('openai');
    // config can be null if integration is inactive or missing.

    // Build messages with system prompt
    const messages: ChatMessage[] = [
      {
        role: 'system',
        content: this.getSystemPrompt(countryCode),
      },
      ...conversationHistory,
      {
        role: 'user',
        content: userMessage,
      },
    ];

    try {
      // Call OpenAI with function calling.
      // If OpenAI is unreachable, we must return fast (avoid 504 gateway timeouts).
      const response = await this.withTimeout(
        this.openai.chat.completions.create({
        model: resolveOpenAiChatModel(config?.model),
        messages: messages as any,
        functions: this.getFunctions(),
        function_call: 'auto',
        temperature: config?.temperature || 0.7,
        max_tokens: config?.maxTokens || 1000,
        }),
        this.openaiRequestTimeoutMs,
      );

      const choice = response.choices[0];
      let cards: SearchResult[] = [];
      let assistantText = '';

      const msg = choice.message as {
        content?: string | null;
        function_call?: { name: string; arguments?: string } | null;
        tool_calls?: Array<{ type?: string; function?: { name: string; arguments?: string } }>;
      };

      let parsedTool: { name: string; args: Record<string, unknown> } | null = null;
      if (msg.function_call?.name) {
        try {
          parsedTool = {
            name: msg.function_call.name,
            args: JSON.parse(msg.function_call.arguments || '{}') as Record<string, unknown>,
          };
        } catch {
          parsedTool = { name: msg.function_call.name, args: {} };
        }
      } else if (Array.isArray(msg.tool_calls)) {
        const fn = msg.tool_calls.find((t) => t?.type === 'function' && t?.function?.name)?.function;
        if (fn?.name) {
          try {
            parsedTool = { name: fn.name, args: JSON.parse(fn.arguments || '{}') as Record<string, unknown> };
          } catch {
            parsedTool = { name: fn.name, args: {} };
          }
        }
      }

      if (parsedTool) {
        const functionName = parsedTool.name;
        const functionArgs = parsedTool.args;

        if (functionName === 'searchContent') {
          const toolQuery =
            typeof functionArgs.query === 'string' ? functionArgs.query.trim() : '';
          const mergedQuery = [userMessage.trim(), toolQuery].filter(Boolean).join(' ');
          cards = await this.contentSearchService.searchContent({
            query: mergedQuery || toolQuery || userMessage,
            anchorMessage: userMessage,
            types: functionArgs.types as ('listing' | 'tour' | 'product' | 'service')[] | undefined,
            limit: Math.min(10, Math.max(1, Number(functionArgs.limit) || 8)),
            lat: location?.lat,
            lng: location?.lng,
          });
          assistantText = this.composeShortAssistantTextForSearch(userMessage, cards);
        } else if (functionName === 'getCategories') {
          // Model sometimes picks taxonomy for dietary questions — force a real listing search.
          if (/\b(vegetarian|vegan|halal|kosher|plant[-\s]?based)\b/i.test(userMessage)) {
            cards = await this.contentSearchService.searchContent({
              query: userMessage,
              anchorMessage: userMessage,
              types: ['listing'],
              limit: 8,
              lat: location?.lat,
              lng: location?.lng,
            });
            assistantText = this.composeShortAssistantTextForSearch(userMessage, cards);
          } else {
            const categories = await this.contentSearchService.getCategories();
            assistantText = this.composeShortAssistantTextForCategories(userMessage, categories);
          }
        }
      } else {
        assistantText = this.cleanResponseText((msg.content ?? '') as string);
      }

      // Generate suggestions
      const suggestions = this.generateSuggestions(userMessage, cards);

      return {
        text: assistantText,
        cards,
        suggestions,
      };
    } catch (error) {
      // Connection issues / timeouts should not break the whole endpoint.
      // Fall back to DB search + templated response.
      this.logger.error('OpenAI chat error', error);
      const cards = await this.contentSearchService.searchContent({
        query: userMessage,
        anchorMessage: userMessage,
        limit: 8,
        lat: location?.lat,
        lng: location?.lng,
      });

      const assistantText = this.composeShortAssistantTextForSearch(
        userMessage,
        cards,
      );
      const suggestions = this.generateSuggestions(userMessage, cards);

      return {
        text: assistantText,
        cards,
        suggestions,
      };
    }
  }

  private async withTimeout<T>(promise: Promise<T>, ms: number): Promise<T> {
    let timeoutHandle: NodeJS.Timeout | null = null;

    const timeoutPromise = new Promise<T>((_, reject) => {
      timeoutHandle = setTimeout(() => reject(new Error(`OpenAI timeout after ${ms}ms`)), ms);
    });

    try {
      return await Promise.race([promise, timeoutPromise]);
    } finally {
      if (timeoutHandle) clearTimeout(timeoutHandle);
    }
  }

  /**
   * Generate a short assistant message from tool results locally.
   * This avoids a second OpenAI call and reduces timeouts.
   */
  private composeShortAssistantTextForSearch(userMessage: string, cards: SearchResult[]): string {
    if (!cards || cards.length === 0) {
      return `I couldn't find exact matches in Zoea right now. Try a different keyword (e.g. Italian, coffee, hotel, gorilla tour, spa) or name a neighbourhood like Kimihurura, Nyamirambo, or the city centre — I'll search again.`;
    }

    const top = cards.slice(0, 5);
    const options = top
      .map((c, idx) => {
        const subtitle = c.subtitle ? ` — ${c.subtitle}` : '';
        const typeHint =
          c.type === 'tour'
            ? ' (tour)'
            : c.type === 'product'
              ? ' (shop)'
              : c.type === 'service'
                ? ' (bookable service)'
                : '';
        return `${idx + 1}. **${c.title}**${typeHint}${subtitle}`;
      })
      .join(' ');

    const wantsBudget = /(cheap|budget|expensive|premium|price|under|below|over)/i.test(userMessage);
    const wantsNear = /(near|nearby|close|walking|distance)/i.test(userMessage);
    const followUp = wantsBudget
      ? 'Want ideas in a cheaper or more premium range, or a specific area?'
      : wantsNear
        ? 'I can narrow down by area — which part of town are you in?'
        : 'Tap a card for full details and booking where available. Want more like these or a different style?';

    return `Here are some picks from Zoea: ${options}. ${followUp}`;
  }

  private composeShortAssistantTextForCategories(
    userMessage: string,
    categories: Array<{ name: string; slug?: string }>,
  ): string {
    const top = (categories || []).slice(0, 16);
    const names = top.map((c) => c.name).join(', ');
    return `Zoea organises places and bookable offers into categories — for example: ${names}, and more. Which vibe fits you (eat out, go out, culture, stay, shop, essentials, tours)?`;
  }

  /**
   * Get country name from ISO code
   */
  private getCountryName(code?: string): string {
    if (!code) return 'Rwanda';
    
    const countryMap: Record<string, string> = {
      'RW': 'Rwanda',
      'KE': 'Kenya',
      'UG': 'Uganda',
      'TZ': 'Tanzania',
    };
    
    return countryMap[code.toUpperCase()] || 'Rwanda';
  }

  /**
   * Clean response text by removing image markdown syntax
   * Images are shown as cards, not in the text
   */
  private cleanResponseText(text: string): string {
    // Remove image markdown: ![alt](url)
    let cleaned = text.replace(/!\[([^\]]*)\]\([^\)]+\)/g, '');
    
    // Remove multiple consecutive newlines
    cleaned = cleaned.replace(/\n{3,}/g, '\n\n');
    
    // Trim whitespace
    cleaned = cleaned.trim();
    
    return cleaned;
  }

  private getSystemPrompt(countryCode?: string): string {
    const countryName = this.getCountryName(countryCode);
    return `You are **Zoea**, the in-app guide for **Zoea Africa** — a discovery and booking-style app for ${countryName} (users may switch country context; stay relevant to their selected region).

## What the app actually covers
- **Places (listings)**: restaurants & dining (cuisines, cafés, halal, vegan, family-friendly, etc.), nightlife (bars, clubs, lounges), culture & attractions, shopping, essentials (banks, pharmacies, transport tips in listings), outdoor spots, and more — organised by category trees like Explore and Dining.
- **Tours & experiences**: day trips, multi-day tours, safari, gorilla/nature experiences, city tours — often with pricing and duration in the app.
- **Bookable services**: spas, guides, activities attached to merchants.
- **Products / shop**: items sold by merchants through listings.
- **Stays**: hotels and similar listings may show rooms/rates when available.
Users open **cards** from chat to see details, photos, and actions (favourites, booking flows) inside the app.

## What you should do
- **Prioritise grounded answers**: Whenever someone asks for specific spots, tours, shops, services, or “what’s good for…”, call **searchContent** with a clear query (and \`types\` when obvious: listings for places, \`tour\` for excursions, \`product\` / \`service\` when they ask to buy or book a service).
- Call **getCategories** only for taxonomy / “what’s in the app?” questions — **not** for dietary preferences, hunger, or “what’s good to eat” (those must use **searchContent** with keywords like \`vegetarian restaurant Kigali\`, \`vegan dining\`, \`halal food\`).
- When calling **searchContent**, pass **focused keywords only** (e.g. \`Italian restaurant Kimihurura\`, \`restaurants Kigali\`) — **never** copy UI chip text verbatim if it starts with “Try”, “Find”, or “Show me”.
- You **may** give short, accurate **general travel context** for ${countryName} (weather, etiquette, safety basics, transport overview, tipping, best time to visit) in **2–5 sentences**, then steer them to **searchContent** for concrete names.
- **Do not** claim real-time prices, availability, or policies — say “check the listing in the app” when details vary.
- **Do not** give medical, legal, or immigration advice; suggest consulting official sources or professionals.

## Out-of-scope data
- **Events calendars** are not in Zoea search tools — do not promise event listings. You can still chat generally about festivals or seasons if asked.

## Style
- Warm, concise, human — default **2–4 sentences**; stretch to **5** only for trip-planning or safety context.
- **One** clear follow-up question when it helps narrow intent (area, budget, casual vs fine dining, family, dates).
- Use **bold** sparingly; numbered lists when comparing options.
- **Never** include image URLs or \`![...]()\` markdown — images appear as cards from search.

## Example intents (call tools when applicable)
- “Romantic dinner Kigali” / “cheap eats Nyamirambo” → searchContent.
- “Gorilla trekking from Kigali” / “weekend tour” → searchContent with tours.
- “Where’s a pharmacy / ATM?” → searchContent (essentials categories).
- “What categories do you have?” → getCategories.
- “What’s good for vegetarians?” / “vegan options?” → **searchContent** (never getCategories alone).
- “Is June a good month to visit?” → short climate answer, no tool unless they ask for places.

Be helpful, honest about limits, and tie answers to what users can do next in Zoea.`;
  }

  private getFunctions() {
    return [
      {
        name: 'searchContent',
        description:
          'Primary search over Zoea’s database. Use for any concrete discovery: food & drink (cuisine, café, rooftop, brochettes, halal, vegan), nightlife (bar, club, lounge), hotels & stays, attractions & culture, shopping, practical spots (pharmacy, bank), outdoor/recreation, tours (safari, gorilla, city tour, Akagera, Nyungwe), bookable services, and products. Pass focused English keywords plus city or neighbourhood names when the user gives them. Prefer types=[listing] for places; types=[tour] for excursions; add product/service only when they explicitly want to buy or book a service.',
        parameters: {
          type: 'object',
          properties: {
            query: {
              type: 'string',
              description:
                'Focused keywords only (no "Try"/"Find" prefixes), e.g. "Italian restaurant Kimihurura", "restaurants Kigali", "gorilla tour", "pharmacy Kigali".',
            },
            types: {
              type: 'array',
              items: {
                type: 'string',
                enum: ['listing', 'tour', 'product', 'service'],
              },
              description:
                'listing = venues/places/stays; tour = multi-day or experience offers; product = retail; service = bookable add-ons. Omit to search all.',
            },
            limit: {
              type: 'number',
              description: 'Number of merged results (default 5, max 10).',
            },
          },
          required: ['query'],
        },
      },
      {
        name: 'getCategories',
        description:
          'Returns the full category taxonomy. Use only when the user asks how browsing works, what tabs exist, or “what categories are in Zoea”. Do **not** use for food preferences (vegetarian/vegan/halal), restaurants, or “what should I eat” — use searchContent for those.',
        parameters: {
          type: 'object',
          properties: {},
        },
      },
    ];
  }

  private generateSuggestions(userMessage: string, cards: SearchResult[]): string[] {
    const m = userMessage.toLowerCase();
    const suggestions: string[] = [];

    if (cards.length > 0) {
      suggestions.push('Show me more like this');
      if (/(eat|food|restaurant|cafe|coffee|dinner|lunch|drink)/i.test(m)) {
        suggestions.push('Fine dining or casual?');
        suggestions.push('What’s good for vegetarians?');
      } else if (/(tour|safari|gorilla|trip|day trip)/i.test(m)) {
        suggestions.push('Multi-day tours');
        suggestions.push('City tours in Kigali');
      } else if (/(hotel|stay|sleep|room)/i.test(m)) {
        suggestions.push('Hotels under my budget');
        suggestions.push('Boutique stays');
      } else if (/(shop|buy|gift|product)/i.test(m)) {
        suggestions.push('Local crafts and gifts');
        suggestions.push('Popular products');
      } else {
        suggestions.push('What’s nearby?');
        suggestions.push('Something for tonight');
      }
    } else {
      suggestions.push('Try restaurants in Kigali');
      suggestions.push('Tours and experiences');
      suggestions.push('What categories exist in Zoea?');
    }

    return [...new Set(suggestions)].slice(0, 3);
  }
}

