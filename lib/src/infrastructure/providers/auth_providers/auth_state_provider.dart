import 'package:agend_app/src/infrastructure/services/auth_services/auth_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authStateProvider = FutureProvider<bool>((ref) async {
  final token = await AuthStorage.getToken();
  return token != null;
});

class AuthStateNotifier extends StateNotifier<AsyncValue<bool>> {
  AuthStateNotifier() : super(const AsyncLoading()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    try {
      final token = await AuthStorage.getToken();
      state = AsyncData(token != null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> loginSuccess() async {
    state = const AsyncData(true);
  }

  Future<void> logout() async {
    await AuthStorage.clearToken();
    state = const AsyncData(false);
  }
}