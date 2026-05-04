import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client;
  AuthService(this._client);

  // ── Auth state stream ─────────────────────────────────────────
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // ── Sign up with email + password ────────────────────────────
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      print('🚀 [AuthService] Attempting signup for: $email');
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      print('✅ [AuthService] Supabase Auth successful. User ID: ${response.user?.id}');

      // Create profile record in public.profiles
      if (response.user != null) {
        print('📝 [AuthService] Creating user profile...');
        await _client.from('profiles').upsert({
          'id': response.user!.id,
          'full_name': fullName,
        });
        print('✨ [AuthService] Profile created successfully.');
      }

      return response;
    } catch (e, stack) {
      print('❌ [AuthService] Signup Error: $e');
      print('📂 [AuthService] Stacktrace: $stack');
      rethrow;
    }
  }

  // ── Sign in ───────────────────────────────────────────────────
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ── Sign out ──────────────────────────────────────────────────
  Future<void> signOut() async => _client.auth.signOut();

  // ── Password reset ────────────────────────────────────────────
  Future<void> resetPassword(String email) async =>
      _client.auth.resetPasswordForEmail(email);

  // ── Get display name ──────────────────────────────────────────
  String get displayName {
    final meta = currentUser?.userMetadata;
    return meta?['full_name'] as String? ??
        currentUser?.email?.split('@').first ??
        'User';
  }
}
