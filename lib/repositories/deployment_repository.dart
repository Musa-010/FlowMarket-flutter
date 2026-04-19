import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../core/network/exceptions/api_exception.dart';
import '../models/deployment/deployment_model.dart';

final deploymentRepositoryProvider = Provider<DeploymentRepository>((ref) {
  return DeploymentRepository(ref.read(apiServiceProvider));
});

class DeploymentRepository {
  DeploymentRepository(this._api);

  final ApiService _api;

  Future<List<Deployment>> getDeployments() async {
    try {
      final response = await _api.getDeployments();
      final payload = response is List
          ? response
          : (response is Map<String, dynamic> && response['data'] is List
                ? response['data'] as List<dynamic>
                : const <dynamic>[]);
      return payload
          .map((item) => Deployment.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch deployments');
    }
  }

  Future<Deployment> getDeployment(String id) async {
    try {
      final response = await _api.getDeployment(id);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Deployment.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch deployment');
    }
  }

  Future<Deployment> createDeployment(Map<String, dynamic> body) async {
    try {
      final response = await _api.createDeployment(body);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Deployment.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to create deployment');
    }
  }

  Future<Deployment> configureDeployment(
    String id,
    Map<String, dynamic> config,
  ) async {
    try {
      final response = await _api.configureDeployment(id, config);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Deployment.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to configure deployment');
    }
  }

  Future<Deployment> pauseDeployment(String id) async {
    try {
      final response = await _api.pauseDeployment(id);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Deployment.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to pause deployment');
    }
  }

  Future<Deployment> resumeDeployment(String id) async {
    try {
      final response = await _api.resumeDeployment(id);
      final payload =
          response is Map<String, dynamic> &&
              response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>);
      return Deployment.fromJson(payload);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to resume deployment');
    }
  }

  Future<List<ExecutionLog>> getDeploymentLogs(String id) async {
    try {
      final response = await _api.getDeploymentLogs(id, {'limit': 50});
      final payload = response is List
          ? response
          : (response is Map<String, dynamic> && response['data'] is List
                ? response['data'] as List<dynamic>
                : const <dynamic>[]);
      return payload
          .map((item) => ExecutionLog.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch logs');
    }
  }
}
