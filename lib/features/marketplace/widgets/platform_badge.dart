import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/workflow/workflow_model.dart';

class PlatformBadge extends StatelessWidget {
  const PlatformBadge({super.key, required this.platform});

  final WorkflowPlatform platform;

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Color textColor, String label) = switch (platform) {
      WorkflowPlatform.n8n => (
        AppColors.primary.withValues(alpha: 0.15),
        AppColors.primary,
        'n8n',
      ),
      WorkflowPlatform.make => (
        const Color(0xFF7F77DD).withValues(alpha: 0.15),
        const Color(0xFF7F77DD),
        'Make',
      ),
      WorkflowPlatform.both => (
        AppColors.surfaceVariant,
        AppColors.textSecondary,
        'n8n + Make',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.full,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: textColor),
      ),
    );
  }
}
