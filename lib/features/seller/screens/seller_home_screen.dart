import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/seller_provider.dart';
import '../widgets/earnings_chart_widget.dart';
import '../widgets/seller_workflow_tile.dart';

class SellerHomeScreen extends ConsumerWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowsAsync = ref.watch(sellerWorkflowsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Seller Dashboard')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/seller/upload'),
        icon: const Icon(Icons.add),
        label: const Text('Upload Workflow'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payout Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                border: Border.all(color: AppColors.warning),
                borderRadius: AppRadius.md,
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Complete payout setup',
                            style: AppTypography.labelMedium),
                        Text(
                          'Connect Stripe to receive payments',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Setup'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StatCard(
                  label: 'Total Revenue',
                  value: '\$1,240',
                  icon: Icons.attach_money,
                  color: AppColors.accent,
                ),
                _StatCard(
                  label: 'Total Sales',
                  value: '47',
                  icon: Icons.shopping_cart_outlined,
                  color: AppColors.primary,
                ),
                _StatCard(
                  label: 'Active Listings',
                  value: '8',
                  icon: Icons.storefront_outlined,
                  color: AppColors.categoryCRM,
                ),
                _StatCard(
                  label: 'Avg. Rating',
                  value: '4.7',
                  icon: Icons.star_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Earnings Chart
            Text('Monthly Earnings', style: AppTypography.h4),
            const SizedBox(height: 8),
            const EarningsChartWidget(
              monthlyEarnings: [450, 620, 380, 890, 1100, 1240],
            ),
            const SizedBox(height: 24),

            // Top Workflows
            Text('Top Performing', style: AppTypography.h4),
            const SizedBox(height: 12),
            workflowsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to load workflows',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.error),
                ),
              ),
              data: (workflows) {
                if (workflows.isEmpty) {
                  return Text(
                    'No workflows yet',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  );
                }
                final top = workflows.take(3).toList();
                return Column(
                  children: top
                      .map((w) => SellerWorkflowTile(workflow: w))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.h3),
          Text(
            label,
            style:
                AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
