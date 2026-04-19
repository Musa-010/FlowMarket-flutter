import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../widgets/earnings_chart_widget.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This Month', style: AppTypography.h4),
            Text(
              '\$1,240',
              style: AppTypography.displayMedium
                  .copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              '+12% from last month',
              style:
                  AppTypography.bodySmall.copyWith(color: AppColors.accent),
            ),
            const SizedBox(height: 24),
            const EarningsChartWidget(
              monthlyEarnings: [450, 620, 380, 890, 1100, 1240],
            ),
            const SizedBox(height: 24),
            Text('Payout History', style: AppTypography.h4),
            const SizedBox(height: 12),
            const _PayoutEntry(
              month: 'March 2026',
              amount: '\$1,100',
              status: 'Processed',
            ),
            const _PayoutEntry(
              month: 'February 2026',
              amount: '\$890',
              status: 'Processed',
            ),
            const _PayoutEntry(
              month: 'January 2026',
              amount: '\$380',
              status: 'Processed',
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('View All Payouts'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayoutEntry extends StatelessWidget {
  const _PayoutEntry({
    required this.month,
    required this.amount,
    required this.status,
  });

  final String month;
  final String amount;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.md,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(month, style: AppTypography.labelMedium),
              Text(
                status,
                style:
                    AppTypography.bodySmall.copyWith(color: AppColors.accent),
              ),
            ],
          ),
          const Spacer(),
          Text(amount, style: AppTypography.h4),
        ],
      ),
    );
  }
}
