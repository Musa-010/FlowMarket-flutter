import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/api_constants.dart';
import '../../storage/secure_storage.dart';

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(ref.read(secureStorageProvider));
});

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  Dio? _dio;

  AuthInterceptor(this._storage);

  void attachDio(Dio dio) => _dio = dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains(
      ApiConstants.refreshToken,
    );
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (isUnauthorized && !isRefreshCall && !alreadyRetried && _dio != null) {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final response = await _dio!.post(
            ApiConstants.refreshToken,
            data: {'refreshToken': refreshToken},
          );
          final data = response.data as Map<String, dynamic>;
          final newAccessToken = data['accessToken'] as String?;
          if (newAccessToken == null || newAccessToken.isEmpty) {
            await _storage.clearTokens();
            return handler.next(err);
          }
          await _storage.saveAccessToken(newAccessToken);

          // Retry the original request with new token
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          err.requestOptions.extra['retried'] = true;
          final retryResponse = await _dio!.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        } catch (_) {
          await _storage.clearTokens();
        }
      }
    }
    handler.next(err);
  }
}
