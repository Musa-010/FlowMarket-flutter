import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/secure_storage.dart';
import '../core/storage/hive_storage.dart';
import '../models/user/user_model.dart';
import '../repositories/auth_repository.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    state = const AsyncValue.loading();
    try {
      final token = await _ref.read(secureStorageProvider).getAccessToken();
      if (token == null) {
        state = const AsyncValue.data(null);
        return;
      }
      final user = await _ref.read(authRepositoryProvider).getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result =
          await _ref.read(authRepositoryProvider).login(email, password);
      await _ref.read(secureStorageProvider).saveTokens(
            accessToken: result.accessToken,
            refreshToken: result.refreshToken,
          );
      state = AsyncValue.data(result.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    UserRole role = UserRole.buyer,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _ref.read(authRepositoryProvider).register(
            fullName: fullName,
            email: email,
            password: password,
            role: role,
          );
      await _ref.read(secureStorageProvider).saveTokens(
            accessToken: result.accessToken,
            refreshToken: result.refreshToken,
          );
      state = AsyncValue.data(result.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _ref.read(secureStorageProvider).clearTokens();
    await _ref.read(hiveStorageProvider).clearCache();
    state = const AsyncValue.data(null);
  }

  bool get isLoggedIn => state.value != null;
}
