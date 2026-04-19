import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../core/network/exceptions/api_exception.dart';
import '../models/user/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(apiServiceProvider));
});

class AuthRepository {
  final ApiService _api;

  AuthRepository(this._api);

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
          : const ApiException(message: 'Failed to send reset link');
    }
  }
}
