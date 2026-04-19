import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/user/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/avatar_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: Column(
            children: [
              // Profile Header
              _ProfileHeader(user: user),

              const SizedBox(height: AppSpacing.xxl),

              // Account Section
              _buildMenuSection(
                context: context,
                isDark: isDark,
                title: 'Account',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    label: 'Edit Profile',
                    onTap: () => context.push('/profile/edit'),
                  ),
                  _MenuItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'My Purchases',
                    onTap: () => context.go('/purchases'),
                  ),
                  _MenuItem(
                    icon: Icons.rocket_launch_outlined,
                    label: 'My Deployments',
                    onTap: () => context.push('/deployments'),
                  ),
                  _MenuItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Billing & Subscription',
                    onTap: () => context.push('/profile/billing'),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Seller Section
              if (user.role == UserRole.seller)
                _buildMenuSection(
                  context: context,
                  isDark: isDark,
                  title: 'Seller',
                  items: [
                    _MenuItem(
                      icon: Icons.storefront_outlined,
                      label: 'Seller Dashboard',
                      onTap: () => context.push('/seller'),
                    ),
                  ],
                ),

              if (user.role == UserRole.buyer)
                _buildMenuSection(
                  context: context,
                  isDark: isDark,
                  title: 'Seller',
                  items: [
                    _MenuItem(
                      icon: Icons.storefront_outlined,
                      label: 'Become a Seller',
                      onTap: () => context.push('/seller/onboarding'),
                    ),
                  ],
                ),

              const SizedBox(height: AppSpacing.lg),

              // Settings Section
              _buildMenuSection(
                context: context,
                isDark: isDark,
                title: 'Settings',
                items: [
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () => context.push('/profile/notifications'),
                  ),
                  _MenuItem(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    trailing: Switch.adaptive(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (_) =>
                          ref.read(themeModeProvider.notifier).toggle(),
                      activeTrackColor: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Support Section
              _buildMenuSection(
                context: context,
                isDark: isDark,
                title: 'Support',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Help Center',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    label: 'Terms of Service',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.shield_outlined,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Sign Out
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppButton(
                  label: 'Sign Out',
                  variant: AppButtonVariant.outlined,
                  icon: Icons.logout,
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Version
              Text(
                'FlowMarket v1.0.0',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required BuildContext context,
    required bool isDark,
    required String title,
    required List<_MenuItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.md,
              side: BorderSide(
                color: isDark ? AppColors.borderDarkMode : AppColors.border,
              ),
            ),
            color: isDark ? AppColors.surfaceDark : AppColors.background,
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  ListTile(
                    leading: Icon(
                      items[i].icon,
                      size: 22,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      items[i].label,
                      style: AppTypography.bodyMedium,
                    ),
                    trailing: items[i].trailing ??
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: AppColors.textTertiary,
                        ),
                    onTap: items[i].onTap,
                  ),
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      indent: AppSpacing.section,
                      color:
                          isDark ? AppColors.borderDarkMode : AppColors.border,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AvatarWidget(
          name: user.fullName,
          imageUrl: user.avatarUrl,
          size: 80,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(user.fullName, style: AppTypography.h3),
        const SizedBox(height: AppSpacing.xs),
        Text(
          user.email,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (user.stripeCustomerId != null) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: AppRadius.full,
            ),
            child: Text(
              'Pro Member',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
  });
}
