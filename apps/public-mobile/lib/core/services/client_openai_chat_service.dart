import 'package:dio/dio.dart';

/// Credentials for a single Chat Completions request (from dart-define or `GET /assistant/client-openai-config`).
class OpenAiClientCredentials {
  final String apiKey;
  final String model;
  final int maxTokens;
  final double temperature;

  const OpenAiClientCredentials({
    required this.apiKey,
    required this.model,
    this.maxTokens = 800,
    this.temperature = 0.7,
  });
}

/// Result of a device-side OpenAI chat completion (no tools / no listing cards).
class ClientOpenAiChatResult {
  final String text;
  final List<Map<String, dynamic>> cards;
  final List<String> suggestions;

  const ClientOpenAiChatResult({
    required this.text,
    this.cards = const [],
    this.suggestions = const [],
  });
}

/// Minimal OpenAI Chat Completions call from the mobile app.
class ClientOpenAiChatService {
  ClientOpenAiChatService._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openai.com/v1',
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 90),
      headers: const {
        'Content-Type': 'application/json',
      },
    ),
  );

  static String _countryName(String? code) {
    if (code == null || code.isEmpty) return 'Rwanda';
    switch (code.toUpperCase()) {
      case 'RW':
        return 'Rwanda';
      case 'KE':
        return 'Kenya';
      case 'UG':
        return 'Uganda';
      case 'TZ':
        return 'Tanzania';
      default:
        return 'Rwanda';
    }
  }

  static String _systemPrompt(String? countryCode) {
    final countryName = _countryName(countryCode);
    return '''You are Zoea, a friendly AI assistant for Zoea Africa — a travel and discovery app focused on $countryName.

Keep replies short (2–4 sentences), warm, and helpful. Ask at most one follow-up question.
Do not mention events. Never use markdown images or image URLs.
You can use **bold** sparingly and simple numbered lists when listing options.''';
  }

  static List<String> _defaultSuggestions() => [
        'Show me popular places',
        'Find restaurants in Kigali',
        'What tours are available?',
      ];

  static String _cleanResponseText(String text) {
    var cleaned = text.replaceAll(RegExp(r'!\[([^\]]*)\]\([^\)]+\)'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return cleaned.trim();
  }

  /// [priorMessages]: OpenAI roles `user` / `assistant` with `content` (no system).
  static Future<ClientOpenAiChatResult> complete({
    required OpenAiClientCredentials credentials,
    required String userMessage,
    required List<Map<String, String>> priorMessages,
    String? countryCode,
  }) async {
    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': _systemPrompt(countryCode)},
      ...priorMessages.map((m) => {'role': m['role'], 'content': m['content'] ?? ''}),
      {'role': 'user', 'content': userMessage},
    ];

    final response = await _dio.post<Map<String, dynamic>>(
      '/chat/completions',
      options: Options(
        headers: {'Authorization': 'Bearer ${credentials.apiKey}'},
      ),
      data: {
        'model': credentials.model,
        'messages': messages,
        'max_tokens': credentials.maxTokens,
        'temperature': credentials.temperature,
      },
    );

    final choice = response.data?['choices'];
    dynamic content;
    if (choice is List && choice.isNotEmpty) {
      final first = choice.first;
      if (first is Map) {
        final msg = first['message'];
        if (msg is Map) {
          content = msg['content'];
        }
      }
    }
    final text = _cleanResponseText((content ?? '').toString());
    if (text.isEmpty) {
      return ClientOpenAiChatResult(
        text: 'I could not generate a reply. Please try again.',
        suggestions: _defaultSuggestions(),
      );
    }

    return ClientOpenAiChatResult(
      text: text,
      suggestions: _defaultSuggestions(),
    );
  }
}
