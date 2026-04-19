import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_button.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.isPopular = false,
    this.isYearly = false,
    this.isLoading = false,
    this.onSelect,
  });

  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<(String label, bool included)> features;
  final bool isPopular;
  final bool isYearly;
  final bool isLoading;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final price = isYearly
        ? yearlyPrice.toStringAsFixed(0)
        : monthlyPrice.toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: isPopular ? AppColors.primary : AppColors.border,
          width: isPopular ? 2 : 1,
        ),
        borderRadius: AppRadius.lg,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan name
              Text(name, style: AppTypography.h3),
              const SizedBox(height: 4),

              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$$price',
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '/month',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              if (isYearly)
                Text(
                  'Billed annually',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Features list
              ...List.generate(features.length, (index) {
                final (label, included) = features[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < features.length - 1 ? 8 : 0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        included
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 20,
                        color: included
                            ? AppColors.accent
                            : AppColors.textDisabled,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: AppTypography.bodyMedium.copyWith(
                            color: included
                                ? AppColors.textPrimary
                                : AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),

              // CTA button
              AppButton(
                label: 'Get Started',
                onPressed: isLoading ? null : onSelect,
                isLoading: isLoading,
                variant: isPopular
                    ? AppButtonVariant.primary
                    : AppButtonVariant.outlined,
              ),
            ],
          ),

          // "MOST POPULAR" badge
          if (isPopular)
            Positioned(
              top: -4,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'MOST POPULAR',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
