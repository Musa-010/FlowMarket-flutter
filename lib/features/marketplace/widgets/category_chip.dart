import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/workflow/workflow_model.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final WorkflowCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  static String labelFor(WorkflowCategory category) {
    return switch (category) {
      WorkflowCategory.email => 'Email Outreach',
      WorkflowCategory.leadGen => 'Lead Gen',
      WorkflowCategory.crm => 'CRM Sync',
      WorkflowCategory.social => 'Social Media',
      WorkflowCategory.invoice => 'Invoicing',
      WorkflowCategory.ecom => 'E-Commerce',
      WorkflowCategory.report => 'Reporting',
      WorkflowCategory.notif => 'Notifications',
      WorkflowCategory.custom => 'Custom',
    };
  }

  static Color colorFor(WorkflowCategory category) {
    return switch (category) {
      WorkflowCategory.email => AppColors.categoryEmail,
      WorkflowCategory.leadGen => AppColors.categoryLead,
      WorkflowCategory.crm => AppColors.categoryCRM,
      WorkflowCategory.social => AppColors.categorySocial,
      WorkflowCategory.invoice => AppColors.categoryInvoice,
      WorkflowCategory.ecom => AppColors.categoryEcom,
      WorkflowCategory.report => AppColors.categoryReport,
      WorkflowCategory.notif => AppColors.categoryNotif,
      WorkflowCategory.custom => AppColors.categoryCustom,
    };
  }

  static IconData iconFor(WorkflowCategory category) {
    return switch (category) {
      WorkflowCategory.email => Icons.email_outlined,
      WorkflowCategory.leadGen => Icons.person_search_outlined,
      WorkflowCategory.crm => Icons.sync_outlined,
      WorkflowCategory.social => Icons.share_outlined,
      WorkflowCategory.invoice => Icons.receipt_long_outlined,
      WorkflowCategory.ecom => Icons.shopping_cart_outlined,
      WorkflowCategory.report => Icons.bar_chart_outlined,
      WorkflowCategory.notif => Icons.notifications_outlined,
      WorkflowCategory.custom => Icons.tune_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(category);
    final bgColor = isSelected ? color : color.withValues(alpha: 0.15);
    final fgColor = isSelected ? Colors.white : color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.full,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconFor(category), size: 16, color: fgColor),
            const SizedBox(width: 6),
            Text(
              labelFor(category),
              style: AppTypography.labelMedium.copyWith(color: fgColor),
            ),
          ],
        ),
      ),
    );
  }
}
