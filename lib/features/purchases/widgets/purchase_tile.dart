import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/purchase/purchase_model.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../marketplace/widgets/category_chip.dart';

class PurchaseTile extends StatelessWidget {
  const PurchaseTile({
    super.key,
    required this.purchase,
    this.onDeploy,
    this.onDownload,
    this.onReview,
  });

  final Purchase purchase;
  final VoidCallback? onDeploy;
  final VoidCallback? onDownload;
  final VoidCallback? onReview;

  @override
  Widget build(BuildContext context) {
    final workflow = purchase.workflow;
    final hasImage = workflow?.previewImages.isNotEmpty == true;
    final category = workflow?.category;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.md,
      ),
      child: Column(
        children: [
          // Main info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppRadius.sm,
                child: hasImage
                    ? CachedNetworkImage(
                        imageUrl: workflow!.previewImages.first,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 60,
                          height: 60,
                          color: AppColors.surfaceVariant,
                        ),
                        errorWidget: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workflow?.title ?? 'Workflow',
                      style: AppTypography.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (category != null) ...[
                      _buildCategoryPill(category),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      'Purchased: ${Formatters.date(purchase.createdAt ?? DateTime.now())}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '\$${purchase.pricePaid.toStringAsFixed(0)}',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 14,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Purchased',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action buttons row
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.rocket_launch_outlined,
                  label: 'Deploy',
                  color: AppColors.primary,
                  onTap: onDeploy,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: Icons.download_outlined,
                  label: 'Download',
                  onTap: onDownload,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: Icons.star_outline_rounded,
                  label: 'Review',
                  onTap: onReview,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.auto_awesome_mosaic_outlined,
        size: 24,
        color: AppColors.textTertiary,
      ),
    );
  }

  Widget _buildCategoryPill(WorkflowCategory category) {
    final color = CategoryChip.colorFor(category);
    final label = CategoryChip.labelFor(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.full,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondary;

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: AppTypography.labelSmall),
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveColor,
        side: BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
