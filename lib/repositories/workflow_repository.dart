import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../core/network/exceptions/api_exception.dart';
import '../core/constants/api_constants.dart';
import '../models/workflow/workflow_model.dart';
import '../models/common/paginated_response.dart';

final workflowRepositoryProvider = Provider<WorkflowRepository>((ref) {
  return WorkflowRepository(ref.read(apiServiceProvider));
});

class WorkflowRepository {
  final ApiService _api;

  WorkflowRepository(this._api);

  Future<PaginatedResponse<Workflow>> getWorkflows({
    int page = 1,
    int limit = ApiConstants.defaultPageSize,
    WorkflowFilter? filter,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (filter != null) {
        if (filter.search != null) queryParams['search'] = filter.search;
        if (filter.category != null) {
          queryParams['category'] = filter.category!.name.toUpperCase();
        }
        if (filter.platform != null) {
          queryParams['platform'] = filter.platform!.name.toUpperCase();
        }
        if (filter.minPrice != null) queryParams['minPrice'] = filter.minPrice;
        if (filter.maxPrice != null) queryParams['maxPrice'] = filter.maxPrice;
        if (filter.sort != null) queryParams['sort'] = filter.sort;
      }

      final response = await _api.getWorkflows(queryParams);
      final responseMap = response is Map<String, dynamic>
          ? response
          : <String, dynamic>{};
      final rawData = responseMap['data'];
      final data = rawData is List ? rawData : const <dynamic>[];
      final total = (responseMap['total'] as num?)?.toInt() ?? data.length;
      final currentPage = (responseMap['page'] as num?)?.toInt() ?? page;
      final pageLimit = (responseMap['limit'] as num?)?.toInt() ?? limit;
      final hasMore =
          responseMap['hasMore'] as bool? ?? (currentPage * pageLimit < total);

      return PaginatedResponse<Workflow>.fromJson({
        'data': data,
        'total': total,
        'page': currentPage,
        'limit': pageLimit,
        'hasMore': hasMore,
      }, (json) => Workflow.fromJson(json as Map<String, dynamic>));
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch workflows');
    }
  }

  Future<List<Workflow>> getFeaturedWorkflows() async {
    try {
      final response = await _api.getFeaturedWorkflows();
      final payload = response is List
          ? response
          : (response is Map<String, dynamic> && response['data'] is List
                ? response['data'] as List<dynamic>
                : const <dynamic>[]);
      return payload
          .map((item) => Workflow.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch featured workflows');
    }
  }

  Future<Workflow> getBySlug(String slug) async {
    try {
      final response = await _api.getWorkflowBySlug(slug);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Workflow.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch workflow');
    }
  }
}
