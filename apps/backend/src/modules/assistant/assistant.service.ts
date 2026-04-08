import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { OpenAIService } from './openai.service';
import { ChatDto } from './dto/chat.dto';
import { IntegrationsService } from '../integrations/integrations.service';

@Injectable()
export class AssistantService {
  constructor(
    private prisma: PrismaService,
    private openaiService: OpenAIService,
    private integrationsService: IntegrationsService,
  ) {}

  /**
   * Exposes OpenAI integration settings to the mobile app for device-side completions
   * when the API host cannot reach OpenAI. Same source as admin integrations DB.
   * Any authenticated user receives the key — use only with that threat model in mind.
   */
  async getClientOpenAiConfig() {
    type OpenAiIntegrationConfig = {
      apiKey?: string;
      api_key?: string;
      model?: string;
      maxTokens?: number;
      temperature?: number;
    };

    const config = await this.integrationsService.getConfig<OpenAiIntegrationConfig>('openai');
    if (!config) {
      return { enabled: false as const };
    }

    const apiKeyRaw = config.apiKey ?? config.api_key;
    const apiKey = typeof apiKeyRaw === 'string' ? apiKeyRaw.trim() : '';
    if (!apiKey) {
      return { enabled: false as const };
    }

    return {
      enabled: true as const,
      apiKey,
      model: config.model || 'gpt-4-turbo-preview',
      maxTokens: config.maxTokens ?? 1000,
      temperature: config.temperature ?? 0.7,
    };
  }

  /**
   * Create a new conversation
   */
  async createConversation(userId: string, firstMessage?: string) {
    const title = firstMessage 
      ? this.generateTitle(firstMessage)
      : 'New Conversation';

    return this.prisma.assistantConversation.create({
      data: {
        userId,
        title,
      },
    });
  }

  /**
   * Get user's conversations (last 90 days)
   */
  async getConversations(userId: string) {
    const ninetyDaysAgo = new Date();
    ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);

    return this.prisma.assistantConversation.findMany({
      where: {
        userId,
        createdAt: { gte: ninetyDaysAgo },
      },
      orderBy: { lastMessageAt: 'desc' },
      select: {
        id: true,
        title: true,
        createdAt: true,
        lastMessageAt: true,
      },
    });
  }

  /**
   * Get conversation messages
   */
  async getMessages(conversationId: string, userId: string) {
    // Verify ownership
    const conversation = await this.prisma.assistantConversation.findFirst({
      where: { id: conversationId, userId },
    });

    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }

    return this.prisma.assistantMessage.findMany({
      where: { conversationId },
      include: {
        cards: true,
      },
      orderBy: { createdAt: 'asc' },
    });
  }

  /**
   * Send a chat message and get response
   * Supports both authenticated users (with conversation history) and guest users (stateless)
   */
  async chat(userId: string | null, chatDto: ChatDto) {
    const { conversationId, message, location } = chatDto;

    // For guest users (no userId), provide stateless chat without saving history
    if (!userId) {
      const guestClientReply = chatDto.clientAssistantReply?.text?.trim();
      if (guestClientReply) {
        const cards = chatDto.clientAssistantReply?.cards ?? [];
        return {
          conversationId: null,
          assistantMessage: {
            id: null,
            text: guestClientReply,
            createdAt: new Date(),
          },
          cards: cards.map((card) => ({
            type: card.type,
            id: card.id,
            title: card.title,
            subtitle: card.subtitle,
            imageUrl: card.imageUrl,
            route: card.route,
            params: card.params,
          })),
          suggestions:
            chatDto.clientAssistantReply?.suggestions?.length
              ? chatDto.clientAssistantReply.suggestions
              : this.defaultFollowUpSuggestions(),
          isGuest: true,
        };
      }
      const response = await this.openaiService.chat(
        message,
        [], // No conversation history for guests
        location,
        chatDto.countryCode,
      );

      return {
        conversationId: null,
        assistantMessage: {
          id: null,
          text: response.text,
          createdAt: new Date(),
        },
        cards: response.cards,
        suggestions: response.suggestions,
        isGuest: true,
      };
    }

    // For authenticated users, maintain conversation history
    // Get or create conversation
    let conversation;
    if (conversationId) {
      conversation = await this.prisma.assistantConversation.findFirst({
        where: { id: conversationId, userId },
      });
      if (!conversation) {
        throw new NotFoundException('Conversation not found');
      }
    } else {
      conversation = await this.createConversation(userId, message);
    }

    // Get conversation history
    const history = await this.prisma.assistantMessage.findMany({
      where: { conversationId: conversation.id },
      orderBy: { createdAt: 'asc' },
      take: 24, // enough turns for follow-ups without huge token use
    });

    const conversationHistory = history.map(msg => ({
      role: msg.role as 'user' | 'assistant',
      content: msg.text,
    }));

    // Save user message
    await this.prisma.assistantMessage.create({
      data: {
        conversationId: conversation.id,
        role: 'user',
        text: message,
      },
    });

    const clientReplyText = chatDto.clientAssistantReply?.text?.trim();
    if (clientReplyText) {
      return this.persistAssistantReplyAndReturn(
        conversation.id,
        conversationHistory.length === 0 ? conversation.title : undefined,
        clientReplyText,
        chatDto.clientAssistantReply?.cards ?? [],
        chatDto.clientAssistantReply?.suggestions?.length
          ? chatDto.clientAssistantReply.suggestions
          : this.defaultFollowUpSuggestions(),
      );
    }

    // Get AI response (server-side OpenAI when VPS has outbound access)
    const response = await this.openaiService.chat(
      message,
      conversationHistory,
      location,
      chatDto.countryCode,
    );

    return this.persistAssistantReplyAndReturn(
      conversation.id,
      conversationHistory.length === 0 ? conversation.title : undefined,
      response.text,
      response.cards,
      response.suggestions,
    );
  }

  /**
   * Save assistant message + optional cards, bump conversation, return API shape.
   */
  private async persistAssistantReplyAndReturn(
    conversationId: string,
    title: string | undefined,
    assistantText: string,
    cardsInput: Array<{
      type: string;
      id: string;
      title: string;
      subtitle?: string;
      imageUrl?: string;
      route: string;
      params?: Record<string, unknown>;
    }>,
    suggestions: string[],
  ) {
    const assistantMessage = await this.prisma.assistantMessage.create({
      data: {
        conversationId,
        role: 'assistant',
        text: assistantText,
      },
    });

    if (cardsInput.length > 0) {
      await this.prisma.assistantMessageCard.createMany({
        data: cardsInput.map((card) => ({
          messageId: assistantMessage.id,
          type: card.type as any,
          entityId: card.id,
          title: card.title,
          subtitle: card.subtitle || '',
          imageUrl: card.imageUrl,
          route: card.route,
          params: (card.params as object) ?? {},
        })),
      });
    }

    await this.prisma.assistantConversation.update({
      where: { id: conversationId },
      data: { lastMessageAt: new Date() },
    });

    const cards = await this.prisma.assistantMessageCard.findMany({
      where: { messageId: assistantMessage.id },
    });

    return {
      conversationId,
      assistantMessage: {
        id: assistantMessage.id,
        text: assistantMessage.text,
        createdAt: assistantMessage.createdAt,
      },
      cards: cards.map((card) => ({
        type: card.type,
        id: card.entityId,
        title: card.title,
        subtitle: card.subtitle,
        imageUrl: card.imageUrl,
        route: card.route,
        params: card.params,
      })),
      suggestions,
      title,
    };
  }

  private defaultFollowUpSuggestions(): string[] {
    return [
      'Romantic rooftop dinner',
      'Family-friendly restaurants',
      'Day trips outside the city',
    ];
  }

  /**
   * Delete a conversation
   */
  async deleteConversation(conversationId: string, userId: string) {
    const conversation = await this.prisma.assistantConversation.findFirst({
      where: { id: conversationId, userId },
    });

    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }

    await this.prisma.assistantConversation.delete({
      where: { id: conversationId },
    });

    return { success: true, message: 'Conversation deleted' };
  }

  /**
   * Generate conversation title from first message
   */
  private generateTitle(message: string): string {
    // Simple title generation - take first 50 chars
    const title = message.substring(0, 50);
    return title.length < message.length ? `${title}...` : title;
  }

  /**
   * Clean up old conversations (90+ days) - called by cron
   */
  async cleanupOldConversations() {
    const ninetyDaysAgo = new Date();
    ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);

    const result = await this.prisma.assistantConversation.deleteMany({
      where: {
        createdAt: { lt: ninetyDaysAgo },
      },
    });

    return { deleted: result.count };
  }
}

