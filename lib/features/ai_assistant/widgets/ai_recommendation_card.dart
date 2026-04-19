import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../marketplace/widgets/star_rating_widget.dart';

class AiRecommendationCard extends StatelessWidget {
  final Workflow workflow;

  const AiRecommendationCard({super.key, required this.workflow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/marketplace/${workflow.slug}'),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.sm,
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: AppRadius.xs,
              child: workflow.previewImages.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: workflow.previewImages.first,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildPlaceholder(),
                      errorWidget: (context, url, error) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            const SizedBox(width: 10),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          workflow.title,
                          style: AppTypography.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    workflow.shortDescription.isNotEmpty
                        ? workflow.shortDescription
                        : 'Great for automating your workflow',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StarRatingWidget(
                        rating: workflow.avgRating,
                        reviewCount: workflow.reviewCount,
                        size: 12,
                      ),
                      Text(
                        ' \u2022 ',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        '\$${workflow.oneTimePrice?.toStringAsFixed(0) ?? '0'}',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Arrow
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.auto_awesome,
        size: 20,
        color: AppColors.textTertiary,
      ),
    );
  }
}
