import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import 'api_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final configuredBaseUrl = dotenv.env['API_BASE_URL']?.trim();
  final rawUrl = (configuredBaseUrl != null && configuredBaseUrl.isNotEmpty)
      ? configuredBaseUrl.replaceAll(RegExp(r'^"|"$'), '')
      : 'https://api.flowmarket.io/api/v1';
  final baseUrl = rawUrl.endsWith('/') ? rawUrl : '$rawUrl/';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final authInterceptor = ref.read(authInterceptorProvider);
  authInterceptor.attachDio(dio);

  dio.interceptors.addAll([
    authInterceptor,
    ref.read(errorInterceptorProvider),
    if (kDebugMode)
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
  ]);

  return dio;
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref.read(dioProvider));
});
