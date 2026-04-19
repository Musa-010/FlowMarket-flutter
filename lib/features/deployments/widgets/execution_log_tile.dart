import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/deployment/deployment_model.dart';

class ExecutionLogTile extends StatelessWidget {
  final ExecutionLog log;

  const ExecutionLogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          Icon(
            log.success ? Icons.check_circle : Icons.cancel,
            color: log.success ? AppColors.accent : AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.success ? 'Success' : (log.errorMessage ?? 'Failed'),
                  style: AppTypography.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      Formatters.timeAgo(log.executedAt ?? DateTime.now()),
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textTertiary),
                    ),
                    Text(
                      ' \u2022 ',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textTertiary),
                    ),
                    Text(
                      '${log.durationMs}ms',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
