import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();

  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    try {
      print('DEBUG: Starting signup process in SignUpScreen');
      final auth = ref.read(authServiceProvider);
      await auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        fullName: _nameCtrl.text.trim(),
      );
      print('DEBUG: Signup successful, navigating to dashboard');
      if (mounted) context.go('/dashboard');
    } catch (e) {
      print('DEBUG: Signup caught error in screen: $e');
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String raw) {
    print('DEBUG: Raw error message: $raw');
    if (raw.contains('User already registered')) return 'This email is already registered.';
    if (raw.contains('Password should be')) return 'Password must be at least 6 characters.';
    if (raw.contains('network_error')) return 'Network error. Check your internet connection.';
    return 'Error: ${raw.replaceFirst('Exception: ', '').replaceFirst('AuthException: ', '')}';
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
              const SizedBox(height: 48),

              // Back button
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.darkText, size: 18),
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 28),

              Text(
                'Create account.',
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
                'Start building your professional identity.',
                style: TextStyle(fontSize: 14, color: AppColors.darkMuted),
              ).animate().fadeIn(delay: 150.ms, duration: 500.ms),

              const SizedBox(height: 36),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _DarkField(
                      controller: _nameCtrl,
                      label: 'Full Name',
                      hint: 'e.g. Md. Siam Hossain',
                      icon: Icons.person_outline_rounded,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Name is required';
                        if (v.trim().length < 2) return 'Enter a valid name';
                        return null;
                      },
                    ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(begin: 0.2),

                    const SizedBox(height: 16),

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
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2),

                    const SizedBox(height: 16),

                    _DarkField(
                      controller: _passCtrl,
                      label: 'Password',
                      hint: 'At least 6 characters',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.darkMuted, size: 18,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'At least 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 350.ms, duration: 400.ms).slideY(begin: 0.2),

                    const SizedBox(height: 16),

                    _DarkField(
                      controller: _confCtrl,
                      label: 'Confirm Password',
                      hint: 'Repeat your password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscure,
                      validator: (v) {
                        if (v != _passCtrl.text) return 'Passwords do not match';
                        return null;
                      },
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2),

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

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _signup,
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
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5, color: Colors.white),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3),
                              ),
                      ),
                    ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Already have an account? ',
                        style: TextStyle(color: AppColors.darkMuted, fontSize: 14)),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text('Sign in',
                          style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared Dark Field ─────────────────────────────────────────────────────────
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
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                color: AppColors.darkSubtle,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
              color: AppColors.darkText, fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.darkMuted, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.darkMuted, size: 18),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.darkCard,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.darkBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.darkBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
            errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
