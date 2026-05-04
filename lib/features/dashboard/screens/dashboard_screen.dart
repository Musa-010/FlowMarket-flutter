import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../models/user/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/glass_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final firstName = user?.fullName.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                const Text(
                  'DASHBOARD',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: Color(0xFFCEBDFF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hello, $firstName',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your cloud ecosystem is running efficiently.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: const Color(0xFFCAC4D4).withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Stats bento grid
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.rocket_launch_outlined,
                        iconColor: const Color(0xFF4DDCC6),
                        badge: '+2 today',
                        badgeColor: const Color(0xFF4DDCC6),
                        label: 'Active\nDeployments',
                        value: '0',
                        onTap: () => context.push('/deployments'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.toll_outlined,
                        iconColor: const Color(0xFFFFAFD3),
                        badge: 'Credits',
                        badgeColor: const Color(0xFFFFAFD3),
                        label: 'Total\nCredits',
                        value: '0',
                        onTap: () => context.push('/profile/plans'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _StatCard(
                  icon: Icons.analytics_outlined,
                  iconColor: const Color(0xFFCEBDFF),
                  badge: '98% uptime',
                  badgeColor: const Color(0xFFCEBDFF),
                  label: 'Recent Activity',
                  value: '0 Actions',
                  wide: true,
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Usage metrics
                _MetricsCard(),
                const SizedBox(height: AppSpacing.xxl),

                // Quick actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _QuickAction(
                  icon: Icons.add_circle_outline,
                  iconColor: const Color(0xFF4DDCC6),
                  title: 'New Deployment',
                  subtitle: 'Spin up a fresh instance',
                  onTap: () => context.push('/deployments'),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAction(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: const Color(0xFFFFAFD3),
                  title: 'Add Credits',
                  subtitle: 'Top up your balance instantly',
                  onTap: () => context.push('/profile/plans'),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAction(
                  icon: Icons.dns_outlined,
                  iconColor: const Color(0xFFCEBDFF),
                  title: 'View Library',
                  subtitle: 'Access your stored assets',
                  onTap: () => context.push('/purchases'),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAction(
                  icon: Icons.settings_suggest_outlined,
                  iconColor: const Color(0xFFCAC4D4),
                  title: 'Cluster Settings',
                  subtitle: 'Optimize your network flow',
                  onTap: () {},
                ),

                // Seller CTA
                if (user?.role == UserRole.buyer) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  _SellerCta(
                      onTap: () => context.push('/seller/onboarding')),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String badge;
  final Color badgeColor;
  final String label;
  final String value;
  final bool wide;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.badge,
    required this.badgeColor,
    required this.label,
    required this.value,
    this.wide = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(16),
        child: wide
            ? Row(
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: const Color(0xFFCAC4D4)
                                .withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon, color: iconColor, size: 22),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: const Color(0xFFCAC4D4).withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _MetricsCard extends StatelessWidget {
  final _days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final _heights = const [0.4, 0.65, 0.55, 0.85, 0.7, 0.95, 0.6];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Usage Metrics',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  _TimeChip(label: '24H', active: false),
                  const SizedBox(width: 6),
                  _TimeChip(label: '7D', active: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_days.length, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: _heights[i],
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFCEBDFF)
                                    .withValues(alpha: 0.2),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _days.map((d) {
              return Text(
                d,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: const Color(0xFFCAC4D4).withValues(alpha: 0.5),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool active;
  const _TimeChip({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFCEBDFF).withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? const Color(0xFFCEBDFF).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: active
              ? const Color(0xFFCEBDFF)
              : const Color(0xFFCAC4D4).withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _QuickAction({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.12),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: const Color(0xFFCAC4D4).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFFCAC4D4).withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _SellerCta extends StatelessWidget {
  final VoidCallback onTap;
  const _SellerCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you an automation expert?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Earn passive income by selling your workflows',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: const Color(0xFFCAC4D4).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: GlassCard(
              borderRadius: BorderRadius.circular(999),
              opacity: 0.12,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: const Text(
                'Become a Seller',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCEBDFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
