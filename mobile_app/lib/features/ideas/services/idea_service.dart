import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/idea.dart';
import '../../../core/constants/api_constants.dart';

class IdeaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Idea>> getVisibleIdeas({int page = 1, int limit = 10}) async {
    try {
      final offset = (page - 1) * limit;
      final response = await _apiClient.get(
        getIdeasEndpoint,
        queryParams: {
          'limit': limit,
          'offset': offset,
        },
      );

      final dynamic rawData = response['data'];
      final List<dynamic> ideas;

      if (rawData is Map<String, dynamic>) {
        ideas = rawData['ideas'] as List<dynamic>? ?? [];
      } else if (rawData is List<dynamic>) {
        ideas = rawData;
      } else {
        ideas = [];
      }

      return ideas
          .map((json) => Idea.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch visible ideas: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<List<Idea>> getUserIdeas({int page = 1, int limit = 10}) async {
    try {
      final offset = (page - 1) * limit;
      final response = await _apiClient.get(
        getUserIdeasEndpoint,
        queryParams: {
          'limit': limit,
          'offset': offset,
        },
      );

      final ideas = response['data'] as List<dynamic>? ?? [];
      return ideas
          .map((json) => Idea.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch user ideas: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<Idea> getIdeaById(String ideaId) async {
    try {
      final endpoint = getIdeaDetailsEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.get(endpoint);

      return Idea.fromJson(Map<String, dynamic>.from(response['data']));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch idea: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<Idea> createIdea({
    required String title,
    required String description,
    required IdeaVisibility visibility,
    String? communityId,
    String? organisationId,
    List<IdeaCriteriaInput> criteria = const [],
  }) async {
    try {
      final payload = <String, dynamic>{
        'title': title,
        'description': description,
        'visibility': visibilityToString(visibility),
        if (communityId != null && communityId.isNotEmpty)
          'communityId': communityId,
        if (organisationId != null && organisationId.isNotEmpty)
          'organisationId': organisationId,
        if (criteria.isNotEmpty)
          'criteria': criteria.map((item) => item.toJson()).toList(),
      };

      final response = await _apiClient.post(
        createIdeaEndpoint,
        body: payload,
      );

      return Idea.fromJson(Map<String, dynamic>.from(response['data']));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to create idea: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<Idea> updateIdea(
    String ideaId, {
    String? title,
    String? description,
    IdeaVisibility? visibility,
    IdeaStage? stage,
  }) async {
    try {
      final endpoint = updateIdeaEndpoint.replaceFirst('{ideaId}', ideaId);
      final body = <String, dynamic>{};

      if (title != null) {
        body['title'] = title;
      }
      if (description != null) {
        body['description'] = description;
      }
      if (visibility != null) {
        body['visibility'] = visibilityToString(visibility);
      }
      if (stage != null) {
        body['stage'] = stageToString(stage);
      }

      if (body.isEmpty) {
        throw ApiException(
          message: 'No updates provided',
          statusCode: 400,
        );
      }

      final response = await _apiClient.put(endpoint, body: body);

      return Idea.fromJson(Map<String, dynamic>.from(response['data']));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to update idea: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<void> deleteIdea(String ideaId) async {
    try {
      final endpoint = deleteIdeaEndpoint.replaceFirst('{ideaId}', ideaId);
      await _apiClient.delete(endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to delete idea: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<List<EvaluationCriteria>> getIdeaCriteria(String ideaId) async {
    try {
      final endpoint = getIdeaCriteriaEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.get(endpoint);
      final data = response['data'] as List<dynamic>? ?? [];

      final criteria = data
          .map((item) => EvaluationCriteria.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
      criteria.sort((a, b) => a.order.compareTo(b.order));
      return criteria;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch idea criteria: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<EvaluationCriteria> createIdeaCriteria({
    required String ideaId,
    required String name,
    required String description,
  }) async {
    try {
      final endpoint = createIdeaCriteriaEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.post(
        endpoint,
        body: {
          'name': name,
          'description': description,
        },
      );

      return EvaluationCriteria.fromJson(
        Map<String, dynamic>.from(response['data']),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to create criteria: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<EvaluationCriteria> updateIdeaCriteria({
    required String ideaId,
    required String criteriaId,
    String? name,
    String? description,
    int? order,
  }) async {
    try {
      final endpoint = updateIdeaCriteriaEndpoint
          .replaceFirst('{ideaId}', ideaId)
          .replaceFirst('{criteriaId}', criteriaId);

      final body = <String, dynamic>{};
      if (name != null) {
        body['name'] = name;
      }
      if (description != null) {
        body['description'] = description;
      }
      if (order != null) {
        body['order'] = order;
      }

      if (body.isEmpty) {
        throw ApiException(
          message: 'No criteria updates provided',
          statusCode: 400,
        );
      }

      final response = await _apiClient.put(endpoint, body: body);

      return EvaluationCriteria.fromJson(
        Map<String, dynamic>.from(response['data']),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to update criteria: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<void> deleteIdeaCriteria({
    required String ideaId,
    required String criteriaId,
  }) async {
    try {
      final endpoint = deleteIdeaCriteriaEndpoint
          .replaceFirst('{ideaId}', ideaId)
          .replaceFirst('{criteriaId}', criteriaId);
      await _apiClient.delete(endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to delete criteria: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
