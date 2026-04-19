import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

class WorkflowCardShimmer extends StatelessWidget {
  const WorkflowCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.md,
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge row
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 48,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: AppRadius.full,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        height: 20,
                        width: 56,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: AppRadius.full,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Title line 1
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: AppRadius.xs,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Title line 2
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: AppRadius.xs,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Rating + price row
                  Row(
                    children: [
                      Container(
                        height: 14,
                        width: 60,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: AppRadius.xs,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 14,
                        width: 50,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: AppRadius.xs,
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
}
