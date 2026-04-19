import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/deployment/deployment_model.dart';

class DeploymentStatusBadge extends StatelessWidget {
  final DeploymentStatus status;

  const DeploymentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Color fgColor, String label) = switch (status) {
      DeploymentStatus.active => (
          AppColors.accent.withValues(alpha: 0.15),
          AppColors.accent,
          'Active',
        ),
      DeploymentStatus.paused => (
          AppColors.warning.withValues(alpha: 0.15),
          AppColors.warning,
          'Paused',
        ),
      DeploymentStatus.failed => (
          AppColors.error.withValues(alpha: 0.15),
          AppColors.error,
          'Failed',
        ),
      DeploymentStatus.configuring => (
          AppColors.surfaceVariant,
          AppColors.textSecondary,
          'Configuring',
        ),
      DeploymentStatus.stopped => (
          AppColors.surfaceVariant,
          AppColors.textSecondary,
          'Stopped',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: fgColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: fgColor),
          ),
        ],
      ),
    );
  }
}
