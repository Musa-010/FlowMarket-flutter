import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../exceptions/api_exception.dart';

final errorInterceptorProvider = Provider<ErrorInterceptor>((ref) {
  return ErrorInterceptor();
});

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final ApiException apiException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        apiException = const ApiException(
          message: 'Connection timed out. Please check your internet.',
        );
      case DioExceptionType.connectionError:
        apiException = const ApiException(
          message: 'Unable to reach the server. Please check your connection or try again later.',
        );
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        final data = err.response?.data;
        String? serverMessage;
        if (data is Map<String, dynamic>) {
          serverMessage = data['message'] as String?;
        }
        apiException = ApiException(
          message: serverMessage ??
              ApiException.fromStatusCode(statusCode).message,
          statusCode: statusCode,
          data: data,
        );
      case DioExceptionType.cancel:
        apiException = const ApiException(message: 'Request was cancelled.');
      default:
        if (err.error is SocketException) {
          apiException = const ApiException(
            message: 'No internet connection.',
          );
        } else {
          apiException = const ApiException(
            message: 'Something went wrong.',
          );
        }
    }

    handler.next(DioException(
      requestOptions: err.requestOptions,
      error: apiException,
      type: err.type,
      response: err.response,
    ));
  }
}
