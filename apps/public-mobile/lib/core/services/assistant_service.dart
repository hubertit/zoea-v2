import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'client_openai_chat_service.dart';
import 'token_storage_service.dart';

class AssistantService {
  /// Get authenticated Dio instance for API calls
  Future<Dio> _getDio() async {
    return AppConfig.authenticatedDioInstance();
  }

  /// Last [AppConfig.maxChatHistory] messages as OpenAI turns (user/assistant only).
  Future<List<Map<String, String>>> _historyForOpenAi(String conversationId) async {
    try {
      final raw = await getMessages(conversationId);
      if (raw.isEmpty) return [];
      final start = raw.length > AppConfig.maxChatHistory ? raw.length - AppConfig.maxChatHistory : 0;
      final slice = raw.sublist(start);
      return slice.map((m) {
        final role = (m['role'] as String?) ?? 'user';
        final text = (m['text'] as String?) ?? '';
        final openAiRole = role == 'assistant' ? 'assistant' : 'user';
        return <String, String>{'role': openAiRole, 'content': text};
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// 1) dart-define `OPENAI_API_KEY` 2) logged-in: `GET /assistant/client-openai-config` (integration DB)
  Future<OpenAiClientCredentials?> _resolveOpenAiCredentials(bool authed) async {
    final envKey = AppConfig.openAiApiKeyFromEnvironment.trim();
    if (envKey.isNotEmpty) {
      return OpenAiClientCredentials(
        apiKey: envKey,
        model: AppConfig.openAiModelFromEnvironment,
        maxTokens: 800,
        temperature: 0.7,
      );
    }
    if (!authed) return null;
    try {
      final dio = await _getDio();
      final response = await dio.get<Map<String, dynamic>>('/assistant/client-openai-config');
      final data = response.data;
      if (data == null) return null;
      if (data['enabled'] != true) return null;
      final key = data['apiKey'] as String?;
      if (key == null || key.trim().isEmpty) return null;
      final model = (data['model'] as String?)?.trim();
      final maxT = data['maxTokens'];
      final temp = data['temperature'];
      return OpenAiClientCredentials(
        apiKey: key.trim(),
        model: (model != null && model.isNotEmpty) ? model : 'gpt-4o-mini',
        maxTokens: maxT is num ? maxT.toInt().clamp(256, 4096) : 800,
        temperature: temp is num ? temp.toDouble().clamp(0.0, 2.0) : 0.7,
      );
    } catch (_) {
      return null;
    }
  }

  /// Send a chat message
  Future<Map<String, dynamic>> sendMessage({
    required String message,
    String? conversationId,
    Map<String, double>? location,
    String? countryCode,
  }) async {
    if (AppConfig.assistantUsesClientOpenAI) {
      final tokenStorage = await TokenStorageService.getInstance();
      final token = await tokenStorage.getAccessToken();
      final authed = token != null && token.isNotEmpty;

      final creds = await _resolveOpenAiCredentials(authed);
      if (creds != null) {
        return _sendMessageWithClientOpenAI(
          credentials: creds,
          authed: authed,
          message: message,
          conversationId: conversationId,
          location: location,
          countryCode: countryCode,
        );
      }
    }

    try {
      final dio = await _getDio();

      final response = await dio.post(
        '/assistant/chat',
        data: {
          'message': message,
          if (conversationId != null) 'conversationId': conversationId,
          if (location != null)
            'location': {
              'lat': location['lat'],
              'lng': location['lng'],
            },
          if (countryCode != null) 'countryCode': countryCode,
        },
      );

      return Map<String, dynamic>.from(response.data as Map);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _sendMessageWithClientOpenAI({
    required OpenAiClientCredentials credentials,
    required bool authed,
    required String message,
    String? conversationId,
    Map<String, double>? location,
    String? countryCode,
  }) async {
    final prior = conversationId != null ? await _historyForOpenAi(conversationId) : <Map<String, String>>[];

    final completion = await ClientOpenAiChatService.complete(
      credentials: credentials,
      userMessage: message,
      priorMessages: prior,
      countryCode: countryCode,
    );

    if (!authed) {
      return {
        'conversationId': null,
        'assistantMessage': {
          'id': null,
          'text': completion.text,
          'createdAt': DateTime.now().toIso8601String(),
        },
        'cards': completion.cards,
        'suggestions': completion.suggestions,
        'isGuest': true,
      };
    }

    final dio = await _getDio();
    final response = await dio.post(
      '/assistant/chat',
      data: {
        'message': message,
        if (conversationId != null) 'conversationId': conversationId,
        if (location != null)
          'location': {
            'lat': location['lat'],
            'lng': location['lng'],
          },
        if (countryCode != null) 'countryCode': countryCode,
        'clientAssistantReply': {
          'text': completion.text,
          'suggestions': completion.suggestions,
        },
      },
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  /// Get all conversations
  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final dio = await _getDio();

      final response = await dio.get('/assistant/conversations');

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get messages for a conversation
  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final dio = await _getDio();

      final response = await dio.get('/assistant/conversations/$conversationId/messages');

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      final dio = await _getDio();

      await dio.delete('/assistant/conversations/$conversationId');
    } catch (e) {
      rethrow;
    }
  }
}
