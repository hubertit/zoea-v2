/** Default when DB/config omits model or it is unknown. */
export const DEFAULT_OPENAI_CHAT_MODEL = 'gpt-4o-mini';

/** Models OpenAI removed or that commonly 404 on current keys — map to a supported chat model. */
const DEPRECATED_CHAT_MODELS: Record<string, string> = {
  'gpt-4-turbo-preview': DEFAULT_OPENAI_CHAT_MODEL,
  'gpt-4-0125-preview': DEFAULT_OPENAI_CHAT_MODEL,
  'gpt-4-1106-preview': DEFAULT_OPENAI_CHAT_MODEL,
  'gpt-4-vision-preview': DEFAULT_OPENAI_CHAT_MODEL,
};

/**
 * Normalizes integration `config.model` so dead preview IDs never reach the API.
 */
export function resolveOpenAiChatModel(raw?: string | null): string {
  const m = (raw ?? '').trim();
  if (!m) return DEFAULT_OPENAI_CHAT_MODEL;
  const mapped = DEPRECATED_CHAT_MODELS[m.toLowerCase()];
  return mapped ?? m;
}
