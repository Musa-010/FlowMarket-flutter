import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../core/network/exceptions/api_exception.dart';
import '../models/workflow/workflow_model.dart';

final sellerRepositoryProvider = Provider<SellerRepository>((ref) {
  return SellerRepository(ref.read(apiServiceProvider));
});

class SellerRepository {
  SellerRepository(this._api);

  final ApiService _api;

  Future<List<Workflow>> getSellerWorkflows() async {
    try {
      final response = await _api.getSellerWorkflows();
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
          : const ApiException(message: 'Failed to fetch seller workflows');
    }
  }

  Future<Workflow> createWorkflow(Map<String, dynamic> body) async {
    try {
      final response = await _api.createSellerWorkflow(body);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Workflow.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to create workflow');
    }
  }

  Future<Workflow> updateWorkflow(String id, Map<String, dynamic> body) async {
    try {
      final response = await _api.updateSellerWorkflow(id, body);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Workflow.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to update workflow');
    }
  }

  Future<Workflow> submitForReview(String id) async {
    try {
      final response = await _api.submitSellerWorkflow(id);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Workflow.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to submit workflow');
    }
  }

  Future<Map<String, dynamic>> getEarnings() async {
    try {
      final response = await _api.getSellerEarnings();
      return response is Map<String, dynamic> ? response : <String, dynamic>{};
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch earnings');
    }
  }
}
