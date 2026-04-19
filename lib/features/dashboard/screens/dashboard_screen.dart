import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/user/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/section_header.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final firstName = user?.fullName.split(' ').first ?? 'there';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Good morning, $firstName \u{1F44B}',
                      style: AppTypography.h3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/profile/notifications'),
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Plan Banner
              _PlanBanner(onTap: () => context.push('/profile/plans')),

              const SizedBox(height: AppSpacing.xxl),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.play_circle_outline,
                      count: '0',
                      label: 'Active',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.bolt_outlined,
                      count: '0',
                      label: 'Executions',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.shopping_bag_outlined,
                      count: '0',
                      label: 'Purchases',
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Active Deployments
              SectionHeader(
                title: 'Active Deployments',
                actionLabel: 'See All',
                onAction: () => context.push('/deployments'),
              ),
              EmptyStateWidget(
                icon: Icons.rocket_launch_outlined,
                title: 'No active deployments yet',
                actionLabel: 'Browse Marketplace',
                onAction: () => context.go('/marketplace'),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Recent Purchases
              SectionHeader(
                title: 'Recently Purchased',
                actionLabel: 'See All',
                onAction: () => context.push('/purchases'),
              ),
              EmptyStateWidget(
                icon: Icons.shopping_bag_outlined,
                title: 'No purchases yet',
                actionLabel: 'Explore Workflows',
                onAction: () => context.go('/marketplace'),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Recommended For You
              SectionHeader(
                title: 'Recommended For You',
                actionLabel: 'See All',
                onAction: () => context.push('/marketplace'),
              ),
              const EmptyStateWidget(
                icon: Icons.auto_awesome_outlined,
                title: 'Personalized recommendations coming soon',
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Seller CTA (only for buyers)
              if (user?.role == UserRole.buyer)
                _SellerCtaCard(isDark: isDark),

              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _PlanBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.warning, Color(0xFFFAEEDA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to deploy workflows',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Start your free 7-day trial',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppButton(
              label: 'View Plans',
              onPressed: onTap,
              fullWidth: false,
              height: 36,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.borderDarkMode : AppColors.border,
        ),
        borderRadius: AppRadius.md,
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            count,
            style: AppTypography.h2.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerCtaCard extends StatelessWidget {
  final bool isDark;

  const _SellerCtaCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.primaryLight,
        border: Border.all(
          color: isDark ? AppColors.borderDarkMode : AppColors.border,
        ),
        borderRadius: AppRadius.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you an automation expert?',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Earn passive income by selling your workflows',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Become a Seller',
            onPressed: () => context.push('/seller/onboarding'),
            variant: AppButtonVariant.outlined,
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}
