import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../core/network/exceptions/api_exception.dart';
import '../core/constants/api_constants.dart';
import '../models/purchase/purchase_model.dart';
import '../models/common/paginated_response.dart';

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  return PurchaseRepository(ref.read(apiServiceProvider), ref.read(dioProvider));
});

class PurchaseRepository {
  final ApiService _api;
  final Dio _dio;

  PurchaseRepository(this._api, this._dio);

  Future<PaginatedResponse<Purchase>> getPurchases({int page = 1}) async {
    try {
      final response = await _api.getPurchases({
        'page': page,
        'limit': ApiConstants.defaultPageSize,
      });
      final responseMap = response is Map<String, dynamic>
          ? response
          : <String, dynamic>{};
      final rawData = responseMap['data'];
      final data = rawData is List ? rawData : const <dynamic>[];
      final total = (responseMap['total'] as num?)?.toInt() ?? data.length;
      final currentPage = (responseMap['page'] as num?)?.toInt() ?? page;
      final pageLimit =
          (responseMap['limit'] as num?)?.toInt() ??
          ApiConstants.defaultPageSize;
      final hasMore =
          responseMap['hasMore'] as bool? ?? (currentPage * pageLimit < total);

      return PaginatedResponse<Purchase>.fromJson({
        'data': data,
        'total': total,
        'page': currentPage,
        'limit': pageLimit,
        'hasMore': hasMore,
      }, (json) => Purchase.fromJson(json as Map<String, dynamic>));
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch purchases');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String workflowId) async {
    try {
      final response = await _dio.post(
        '/checkout/payment-intent',
        data: {'workflowId': workflowId},
      );
      final data = response.data;
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to create payment intent');
    }
  }

  Future<Map<String, dynamic>> createSetupIntent() async {
    try {
      final response = await _dio.post('/checkout/setup-intent');
      final data = response.data;
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to create setup intent');
    }
  }

  Future<Map<String, dynamic>> createOneTimeCheckout(String workflowId) async {
    try {
      final response = await _api.createOneTimeCheckout({
        'workflowId': workflowId,
      });
      return response is Map<String, dynamic> ? response : <String, dynamic>{};
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to create checkout');
    }
  }

  Future<Map<String, dynamic>> createSubscriptionCheckout(String planId) async {
    try {
      final response = await _api.createSubscriptionCheckout({
        'planId': planId,
      });
      return response is Map<String, dynamic> ? response : <String, dynamic>{};
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(
              message: 'Failed to create subscription checkout',
            );
    }
  }

  Future<Map<String, dynamic>> createSubscriptionIntent(String planId) async {
    try {
      final response = await _dio.post(
        '/checkout/subscription-intent',
        data: {'planId': planId},
      );
      final data = response.data;
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to create subscription intent');
    }
  }

  Future<void> subscribeAfterSetup(String planId) async {
    try {
      await _dio.post(
        '/checkout/subscribe-after-setup',
        data: {'planId': planId},
      );
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to activate subscription');
    }
  }
}
