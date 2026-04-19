import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/utils/validators.dart';
import '../../../repositories/auth_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _emailSent = false;
  bool _isLoading = false;
  int _resendCountdown = 0;
  Timer? _resendTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _onSendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .forgotPassword(_emailController.text.trim());
      if (!mounted) return;
      setState(() {
        _emailSent = true;
        _isLoading = false;
      });
      _startResendCountdown();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _startResendCountdown() {
    setState(() => _resendCountdown = 60);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _onResend() async {
    if (_resendCountdown > 0) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .forgotPassword(_emailController.text.trim());
      if (!mounted) return;
      setState(() => _isLoading = false);
      _startResendCountdown();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: _emailSent ? _buildSuccessState() : _buildFormState(),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.section),

          // Email icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppRadius.full,
              ),
              child: const Icon(
                Icons.email_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // Title
          Center(
            child: Text(
              AppStrings.forgotPassword,
              style: AppTypography.h2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              AppStrings.forgotPasswordSubtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // Email field
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: Validators.email,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Send button
          AppButton(
            label: AppStrings.sendResetLink,
            onPressed: _isLoading ? null : _onSendResetLink,
            isLoading: _isLoading,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Back to login
          Center(
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: Text(
                'Back to Login',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.section),

        // Checkmark icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: AppRadius.full,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 40,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // Title
        Center(
          child: Text(
            'Email Sent!',
            style: AppTypography.h2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            'Check your inbox at ${_emailController.text.trim()}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // Back to login button
        AppButton(
          label: 'Back to Login',
          onPressed: () => context.go('/login'),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Resend
        Center(
          child: _resendCountdown > 0
              ? Text(
                  'Resend in ${_resendCountdown}s',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                )
              : TextButton(
                  onPressed: _isLoading ? null : _onResend,
                  child: Text(
                    'Resend Email',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
