import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../marketplace/widgets/platform_badge.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.workflow});

  final Workflow workflow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: image + details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppRadius.sm,
                child: workflow.previewImages.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: workflow.previewImages.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 80,
                          height: 80,
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
                      workflow.title,
                      style: AppTypography.labelLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    PlatformBadge(platform: workflow.platform),
                    const SizedBox(height: 4),
                    Text(
                      workflow.shortDescription,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Order Summary label
          Text('Order Summary', style: AppTypography.labelMedium),
          const SizedBox(height: 8),

          // Workflow line item
          Row(
            children: [
              Text('Workflow', style: AppTypography.bodyMedium),
              const Spacer(),
              Text(
                Formatters.currency(workflow.oneTimePrice ?? 0),
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Processing fee
          Row(
            children: [
              Text(
                'Processing fee',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const Spacer(),
              Text(
                '\$0.00',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),

          const Divider(),

          // Total
          Row(
            children: [
              Text('Total', style: AppTypography.h4),
              const Spacer(),
              Text(
                Formatters.currency(workflow.oneTimePrice ?? 0),
                style: AppTypography.priceTag,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.auto_awesome_mosaic_outlined,
        color: AppColors.textTertiary,
      ),
    );
  }
}
