import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../models/user/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

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
  int _passwordStrengthValue = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).register(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _wantToSell ? UserRole.seller : UserRole.buyer,
        );
  }

  Color _strengthColor() {
    switch (_passwordStrengthValue) {
      case 0:
        return AppColors.error;
      case 1:
        return AppColors.warning;
      case 2:
        return AppColors.accent;
      default:
        return AppColors.error;
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
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) context.go('/dashboard');
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Header
              Text(AppStrings.createAccount, style: AppTypography.h2),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.createAccountSubtitle,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Full Name
              AppTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                prefixIcon: Icons.person_outlined,
                textInputAction: TextInputAction.next,
                validator: Validators.fullName,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Email
              AppTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Password
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Create a password',
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                textInputAction: TextInputAction.next,
                validator: Validators.password,
                onChanged: (value) {
                  setState(() {
                    _passwordStrengthValue =
                        Validators.passwordStrength(value);
                  });
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              // Password strength indicator
              if (_passwordController.text.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_passwordStrengthValue + 1) / 3,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(_strengthColor()),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _strengthLabel(),
                  style: AppTypography.caption.copyWith(
                    color: _strengthColor(),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),

              // Confirm Password
              AppTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.confirmPassword(
                  value,
                  _passwordController.text,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Seller switch
              Row(
                children: [
                  Switch(
                    value: _wantToSell,
                    onChanged: (value) {
                      setState(() => _wantToSell = value);
                    },
                    activeTrackColor: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'I want to sell workflows',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Create Account button
              AppButton(
                label: AppStrings.createAccount,
                onPressed: isLoading ? null : _onRegister,
                isLoading: isLoading,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // OR divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Text(
                      'OR',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Google sign up
              AppButton(
                label: AppStrings.continueWithGoogle,
                variant: AppButtonVariant.outlined,
                icon: Icons.g_mobiledata,
                onPressed: () {
                  // TODO: Implement Google sign up
                },
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      AppStrings.signIn,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}
