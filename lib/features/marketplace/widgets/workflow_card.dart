import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/price_tag.dart';
import 'category_chip.dart';
import 'platform_badge.dart';
import 'star_rating_widget.dart';

class WorkflowCard extends StatelessWidget {
  const WorkflowCard({
    super.key,
    required this.workflow,
    this.isLarge = false,
  });

  final Workflow workflow;
  final bool isLarge;

  void _onTap(BuildContext context) {
    context.push('/marketplace/${workflow.slug}');
  }

  @override
  Widget build(BuildContext context) {
    return isLarge ? _buildLarge(context) : _buildCompact(context);
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.surfaceVariant,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_mosaic_rounded,
          size: 40,
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildImage(double height) {
    final imageUrl =
        workflow.previewImages.isNotEmpty ? workflow.previewImages.first : null;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => SizedBox(
                height: height,
                child: _buildImagePlaceholder(),
              ),
              errorWidget: (_, __, ___) => SizedBox(
                height: height,
                child: _buildImagePlaceholder(),
              ),
            )
          : SizedBox(
              height: height,
              width: double.infinity,
              child: _buildImagePlaceholder(),
            ),
    );
  }

  Widget _buildCategoryLabel() {
    final color = CategoryChip.colorFor(workflow.category);
    final label = CategoryChip.labelFor(workflow.category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Widget _buildCompact(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceDark
              : Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.md,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildImage(double.infinity)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      PlatformBadge(platform: workflow.platform),
                      _buildCategoryLabel(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    workflow.title,
                    style: AppTypography.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  StarRatingWidget(
                    rating: workflow.avgRating,
                    reviewCount: workflow.reviewCount,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      PriceTag(price: workflow.oneTimePrice ?? 0),
                      const Spacer(),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          onPressed: () => _onTap(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLarge(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceDark
              : Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.md,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildImage(double.infinity)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            PlatformBadge(platform: workflow.platform),
                            _buildCategoryLabel(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      StarRatingWidget(
                        rating: workflow.avgRating,
                        reviewCount: workflow.reviewCount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workflow.title,
                    style: AppTypography.h4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workflow.shortDescription,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (workflow.requiredIntegrations.isNotEmpty) ...[
                    Text(
                      'Required: ${workflow.requiredIntegrations.join(' \u2022 ')}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      PriceTag(price: workflow.oneTimePrice ?? 0),
                      const Spacer(),
                      AppButton(
                        label: 'Buy Now',
                        fullWidth: false,
                        height: 36,
                        onPressed: () => _onTap(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
