import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String body;

  const OnboardingPageWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: AppColors.surfaceVariant,
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        Text(
          title,
          style: AppTypography.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Text(
            body,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
