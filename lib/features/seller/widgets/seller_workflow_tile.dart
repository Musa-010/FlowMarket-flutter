import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../marketplace/widgets/platform_badge.dart';
import '../../marketplace/widgets/star_rating_widget.dart';

class SellerWorkflowTile extends StatelessWidget {
  const SellerWorkflowTile({super.key, required this.workflow, this.onTap});

  final Workflow workflow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workflow.title,
                    style: AppTypography.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      PlatformBadge(platform: workflow.platform),
                      const SizedBox(width: 6),
                      _StatusPill(status: workflow.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StarRatingWidget(
                        rating: workflow.avgRating,
                        reviewCount: workflow.reviewCount,
                      ),
                      Text(
                        ' \u2022 ${workflow.purchaseCount} sales',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${((workflow.oneTimePrice ?? 0) * workflow.purchaseCount).toStringAsFixed(0)}',
                  style: AppTypography.h4.copyWith(color: AppColors.primary),
                ),
                Text(
                  'revenue',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final WorkflowStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (status) {
      WorkflowStatus.approved => (
        AppColors.accentLight,
        AppColors.accent,
        'Live',
      ),
      WorkflowStatus.pendingReview => (
        AppColors.warningLight,
        AppColors.warning,
        'In Review',
      ),
      WorkflowStatus.draft => (
        AppColors.surfaceVariant,
        AppColors.textSecondary,
        'Draft',
      ),
      WorkflowStatus.rejected => (
        AppColors.errorLight,
        AppColors.error,
        'Rejected',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.full,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: fg),
      ),
    );
  }
}
