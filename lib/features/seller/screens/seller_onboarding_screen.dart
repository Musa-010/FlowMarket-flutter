import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_button.dart';

class SellerOnboardingScreen extends ConsumerWidget {
  const SellerOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Become a Seller')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Start Selling on FlowMarket',
                  style: AppTypography.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Share your automation expertise and earn passive income.',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const _BenefitRow(
                  icon: Icons.attach_money,
                  title: '70% Revenue Share',
                  subtitle: 'Keep 70% of every sale',
                ),
                const SizedBox(height: 20),
                const _BenefitRow(
                  icon: Icons.public,
                  title: 'Global Marketplace',
                  subtitle: 'Reach thousands of business owners',
                ),
                const SizedBox(height: 20),
                const _BenefitRow(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Easy Upload',
                  subtitle: 'Upload your workflow in minutes',
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Get Started',
                  onPressed: () => context.push('/seller/upload'),
                ),
                const SizedBox(height: 12),
                Text(
                  'By continuing, you agree to our Seller Terms',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.labelLarge),
              Text(
                subtitle,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
