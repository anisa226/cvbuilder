import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth_service.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/editor/input_screen.dart';
import '../../features/preview/preview_screen.dart';
import '../../features/editor/cv_model.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseClientProvider));
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// ── Router ────────────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<bool>(
    Supabase.instance.client.auth.currentUser != null,
  );

  ref.listen(authStateProvider, (_, next) {
    next.whenData((state) {
      authNotifier.value = state.session != null;
    });
  });

  return GoRouter(
    refreshListenable: authNotifier,
    initialLocation: '/',
    debugLogDiagnostics: true, // This will help us see the routing flow in the console
    redirect: (context, state) {
      final loggedIn = authNotifier.value;
      final path = state.uri.path;
      final onAuthPath = path == '/login' || path == '/signup';

      if (!loggedIn && !onAuthPath && path != '/') {
        return '/login';
      }
      if (loggedIn && onAuthPath) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/editor',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final resumeId   = extra?['resumeId'] as String?;
          final resumeData = extra?['resumeData'] as CVModel?;
          return InputScreen(resumeId: resumeId, initialData: resumeData);
        },
      ),
      GoRoute(
        path: '/preview',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PreviewScreen(
            cvData: extra['cvData'] as CVModel,
            resumeId: extra['resumeId'] as String?,
          );
        },
      ),
    ],
  );
});
