import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/conversation.dart';

class ConversationService {
  final ApiClient _apiClient = ApiClient();

  Future<Conversation?> getIdeaConversation(String ideaId) async {
    try {
      final endpoint = getIdeaConversationEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.get(endpoint);
      final data = response['data'];
      if (data == null) {
        return null;
      }

      return Conversation.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to load conversation: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<Conversation> getOrCreateIdeaConversation(String ideaId) async {
    try {
      final endpoint = createIdeaConversationEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.post(endpoint);
      return Conversation.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to open conversation: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<List<ConversationMessage>> getMessages(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final endpoint = getConversationMessagesEndpoint
          .replaceFirst('{conversationId}', conversationId);

      final response = await _apiClient.get(
        '$endpoint?limit=$limit&offset=$offset',
      );

      final list = (response['data'] as List<dynamic>? ?? []);
      return list
          .map((item) => ConversationMessage.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to load messages: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<ConversationMessage> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      final endpoint = createConversationMessageEndpoint
          .replaceFirst('{conversationId}', conversationId);

      final response = await _apiClient.post(
        endpoint,
        body: {
          'content': content,
        },
      );

      return ConversationMessage.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to send message: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
