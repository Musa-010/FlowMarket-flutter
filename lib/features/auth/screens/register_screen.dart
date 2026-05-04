import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../models/user/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/glass_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _wantToSell = false;
  bool _agreedToTerms = false;
  int _passwordStrengthValue = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service.'),
          backgroundColor: Color(0xFFFFB4AB),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      context.push('/verify-otp', extra: {
        'email': _emailController.text.trim(),
        'fullName': _nameController.text.trim(),
        'password': _passwordController.text,
        'role': _wantToSell ? UserRole.seller : UserRole.buyer,
      });
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: const Color(0xFFFFB4AB)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: const Color(0xFFFFB4AB)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _strengthColor() {
    switch (_passwordStrengthValue) {
      case 0:
        return const Color(0xFFFFB4AB);
      case 1:
        return const Color(0xFFEF9F27);
      case 2:
        return const Color(0xFF4DDCC6);
      default:
        return const Color(0xFFFFB4AB);
    }
  }

  String _strengthLabel() {
    switch (_passwordStrengthValue) {
      case 0:
        return 'Weak';
      case 1:
        return 'Fair';
      case 2:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: const Color(0xFFFFB4AB),
            ),
          );
        },
      );
    });
    final isLoading = _isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: Column(
          children: [
            // Header with close button
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    GlassCard(
                      borderRadius: BorderRadius.circular(999),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.close,
                                color: Color(0xFFCEBDFF), size: 16),
                            SizedBox(width: 4),
                            Text(
                              'CLOSE',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                color: Color(0xFFE0E3E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                  vertical: AppSpacing.lg,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GlassCard(
                        borderRadius: BorderRadius.circular(28),
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Join the ethereal marketplace today.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: const Color(0xFFCAC4D4)
                                    .withValues(alpha: 0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),

                            // Full name
                            GlassTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              hint: 'John Doe',
                              prefixIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              validator: Validators.fullName,
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Email
                            GlassTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'name@flowmarket.com',
                              prefixIcon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Password
                            GlassTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: '••••••••',
                              prefixIcon: Icons.lock_outline,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              validator: Validators.password,
                              onChanged: (v) => setState(() {
                                _passwordStrengthValue =
                                    Validators.passwordStrength(v);
                              }),
                            ),
                            if (_passwordController.text.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value:
                                      (_passwordStrengthValue + 1) / 3,
                                  backgroundColor: Colors.white
                                      .withValues(alpha: 0.1),
                                  valueColor: AlwaysStoppedAnimation(
                                      _strengthColor()),
                                  minHeight: 4,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                _strengthLabel(),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: _strengthColor(),
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.lg),

                            // Confirm password
                            GlassTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              hint: '••••••••',
                              prefixIcon: Icons.verified_user_outlined,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: (v) =>
                                  Validators.confirmPassword(
                                v,
                                _passwordController.text,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Seller toggle
                            Row(
                              children: [
                                Switch(
                                  value: _wantToSell,
                                  onChanged: (v) =>
                                      setState(() => _wantToSell = v),
                                  thumbColor: WidgetStateProperty.resolveWith(
                                    (s) => s.contains(WidgetState.selected)
                                        ? const Color(0xFF8B5CF6)
                                        : const Color(0xFF948E9D),
                                  ),
                                  trackColor: WidgetStateProperty.resolveWith(
                                    (s) => s.contains(WidgetState.selected)
                                        ? const Color(0xFF8B5CF6).withValues(alpha: 0.3)
                                        : Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    'I want to sell workflows',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: const Color(0xFFCAC4D4)
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Terms checkbox
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _agreedToTerms,
                                    onChanged: (v) => setState(
                                        () => _agreedToTerms = v ?? false),
                                    side: BorderSide(
                                      color: Colors.white
                                          .withValues(alpha: 0.2),
                                    ),
                                    fillColor:
                                        WidgetStateProperty.resolveWith(
                                      (states) =>
                                          states.contains(WidgetState.selected)
                                              ? const Color(0xFF8B5CF6)
                                              : Colors.transparent,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        color: const Color(0xFFCAC4D4)
                                            .withValues(alpha: 0.8),
                                      ),
                                      children: const [
                                        TextSpan(
                                            text:
                                                'I agree to the '),
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style: TextStyle(
                                              color: Color(0xFFCEBDFF)),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                              color: Color(0xFFCEBDFF)),
                                        ),
                                        TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xxl),

                            // Create account button
                            GlassButton(
                              label: AppStrings.createAccount,
                              onPressed: isLoading ? null : _onRegister,
                              isLoading: isLoading,
                            ),
                            const SizedBox(height: AppSpacing.xxl),

                            const GlassDivider(label: 'OR SIGN UP WITH'),
                            const SizedBox(height: AppSpacing.lg),

                            // Social buttons
                            Row(
                              children: [
                                Expanded(
                                  child: _SocialWideButton(
                                    label: 'Google',
                                    icon: const Icon(Icons.g_mobiledata,
                                        color: Color(0xFFE0E3E5), size: 20),
                                    onPressed: isLoading
                                        ? null
                                        : () => ref
                                            .read(authProvider.notifier)
                                            .loginWithGoogle(),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: _SocialWideButton(
                                    label: 'Apple',
                                    icon: const Icon(Icons.apple,
                                        color: Color(0xFFE0E3E5), size: 20),
                                    onPressed: isLoading
                                        ? null
                                        : () => ref
                                            .read(authProvider.notifier)
                                            .loginWithApple(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Login link
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: const Color(0xFFCAC4D4)
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFCEBDFF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Info bento cards
                      Row(
                        children: [
                          Expanded(
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.security,
                                      color: Color(0xFF4DDCC6), size: 22),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Secure Data',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'AES-256 encrypted storage for your digital assets.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      color: const Color(0xFFCAC4D4)
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.speed,
                                      color: Color(0xFFFFAFD3), size: 22),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Instant Sync',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Real-time marketplace updates across all devices.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      color: const Color(0xFFCAC4D4)
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialWideButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  const _SocialWideButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: GlassCard(
        borderRadius: BorderRadius.circular(999),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE0E3E5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
