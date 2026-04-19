import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.size = 14,
  });

  final double rating;
  final int reviewCount;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i < rating.floor()
                ? Icons.star_rounded
                : i < rating
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            size: size,
            color: i < rating ? Colors.amber : Colors.grey.shade300,
          ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTypography.labelMedium,
        ),
        Text(
          ' ($reviewCount)',
          style: AppTypography.caption.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
