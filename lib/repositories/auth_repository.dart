import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../core/network/exceptions/api_exception.dart';
import '../models/user/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(apiServiceProvider), ref.read(dioProvider));
});

class AuthRepository {
  final ApiService _api;
  final Dio _dio;

  AuthRepository(this._api, this._dio);

  Future<AuthResponse> login(String email, String password) async {
    try {
      return await _api.login({'email': email, 'password': password});
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Login failed');
    }
  }

  Future<AuthResponse> register({
    required String fullName,
    required String email,
    required String password,
    UserRole role = UserRole.buyer,
  }) async {
    try {
      return await _api.register({
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role.name.toUpperCase(),
      });
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Registration failed');
    }
  }

  Future<User> getCurrentUser() async {
    try {
      return await _api.getCurrentUser();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to fetch user');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _api.forgotPassword({'email': email});
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to send reset code');
    }
  }

  Future<String> verifyResetOtp(String email, String otp) async {
    try {
      final res = await _api.verifyResetOtp({'email': email, 'otp': otp});
      return (res as Map<String, dynamic>)['resetToken'] as String;
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Invalid or expired code');
    }
  }

  Future<void> resetPassword(String resetToken, String newPassword) async {
    try {
      await _api.resetPassword({'resetToken': resetToken, 'newPassword': newPassword});
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to reset password');
    }
  }

  Future<AuthResponse> loginWithGoogle(String firebaseIdToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.googleAuth,
        data: {'idToken': firebaseIdToken},
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Google sign-in failed');
    }
  }

  Future<AuthResponse> loginWithApple(String firebaseIdToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.appleAuth,
        data: {'idToken': firebaseIdToken},
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Apple sign-in failed');
    }
  }
}
