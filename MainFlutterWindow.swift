import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Logo mark ─────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.green, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.4),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.description_rounded,
                color: Colors.white,
                size: 38,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.06, 1.06),
                  duration: 900.ms,
                  curve: Curves.easeInOut,
                ),

            const SizedBox(height: 28),

            // ── App name ──────────────────────────────────────
            Text(
              'CV Studio Pro',
              style: TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

            const SizedBox(height: 8),

            Text(
              'Your career, perfected.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkMuted,
                letterSpacing: 0.3,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

            const SizedBox(height: 60),

            // ── Loading indicator ─────────────────────────────
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.accent.withOpacity(0.7),
                ),
              ),
            ).animate().fadeIn(delay: 900.ms),
          ],
        ),
      ),
    );
  }
}
