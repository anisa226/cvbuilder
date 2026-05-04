import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  bool _loading    = false;
  bool _obscure    = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    try {
      final auth = ref.read(authServiceProvider);
      await auth.signIn(email: _emailCtrl.text.trim(), password: _passCtrl.text);
      if (mounted) context.go('/dashboard');
    } catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Enter your email first, then tap Forgot Password.');
      return;
    }
    await ref.read(authServiceProvider).resetPassword(email);
    if (mounted) {
      _showSnack('Reset link sent! Check your inbox.');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _friendlyError(String raw) {
    if (raw.contains('Invalid login')) return 'Incorrect email or password.';
    if (raw.contains('Email not confirmed')) return 'Please verify your email first.';
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // ── Brand mark ──────────────────────────────────
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.green, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.description_rounded,
                    color: Colors.white, size: 24),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3),

              const SizedBox(height: 32),

              Text(
                'Welcome back.',
                style: TextStyle(
                  fontFamily: 'Cormorant Garamond',
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                  letterSpacing: -1.0,
                  height: 1.0,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 500.ms),

              const SizedBox(height: 8),

              Text(
                'Sign in to continue building your career.',
                style: TextStyle(fontSize: 14, color: AppColors.darkMuted),
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

              const SizedBox(height: 40),

              // ── Form ─────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _DarkField(
                      controller: _emailCtrl,
                      label: 'Email',
                      hint: 'you@email.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.2),

                    const SizedBox(height: 16),

                    _DarkField(
                      controller: _passCtrl,
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.darkMuted,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'At least 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.2),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _forgotPassword,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.error.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                color: AppColors.error, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(_error!,
                                  style: const TextStyle(
                                      color: AppColors.error, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // ── Login button ────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Divider ───────────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.darkBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('OR',
                        style: TextStyle(color: AppColors.darkMuted, fontSize: 11)),
                  ),
                  Expanded(child: Divider(color: AppColors.darkBorder)),
                ],
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 24),

              // ── Sign up link ─────────────────────────────────
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.darkMuted, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Text(
                        'Sign up free',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dark-themed input field ────────────────────────────────────────────────────

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _DarkField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            color: AppColors.darkSubtle,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: AppColors.darkText,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.darkMuted, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.darkMuted, size: 18),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.darkCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
