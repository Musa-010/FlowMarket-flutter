import 'package:flutter/material.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_colors.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final bool isMonthly;

  const PriceTag({
    super.key,
    required this.price,
    this.isMonthly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '\$${price.toStringAsFixed(0)}',
          style: AppTypography.priceTag,
        ),
        if (isMonthly)
          Text(
            '/mo',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
