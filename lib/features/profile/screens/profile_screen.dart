import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/user/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/glass_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final themeMode = ref.watch(themeModeProvider);

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF101415),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFCEBDFF),
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: Column(
          children: [
            // Glass header
            SafeArea(
              bottom: false,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu,
                          color: const Color(0xFFCEBDFF).withValues(alpha: 0.8),
                        ),
                        const Spacer(),
                        GradientText(
                          'FlowMarket',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.notifications_outlined,
                          color: const Color(0xFFCEBDFF).withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 100),
                child: Column(
                  children: [
                    // Hero avatar
                    _ProfileHero(user: user),
                    const SizedBox(height: 32),

                    // Account items
                    _GlassMenuItem(
                      icon: Icons.edit_outlined,
                      iconColor: const Color(0xFFA78BFA),
                      label: 'Edit Profile',
                      subtitle: 'Update your bio and details',
                      onTap: () => context.push('/profile/edit'),
                    ),
                    const SizedBox(height: 12),
                    _GlassMenuItem(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: const Color(0xFF4DDCC6),
                      label: 'Billing',
                      subtitle: 'Payment methods and history',
                      onTap: () => context.push('/profile/billing'),
                    ),
                    const SizedBox(height: 12),
                    _GlassMenuItem(
                      icon: Icons.notifications_active_outlined,
                      iconColor: const Color(0xFFFFAFD3),
                      label: 'Notifications',
                      subtitle: 'Manage alert preferences',
                      onTap: () => context.push('/profile/notifications'),
                    ),
                    const SizedBox(height: 12),
                    _GlassMenuItem(
                      icon: Icons.card_membership_outlined,
                      iconColor: const Color(0xFFCEBDFF),
                      label: 'Plans',
                      subtitle: 'View your current subscription',
                      badge: user.stripeCustomerId != null ? 'PRO' : null,
                      onTap: () => context.push('/profile/billing'),
                    ),
                    const SizedBox(height: 12),
                    _GlassMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      iconColor: const Color(0xFFA78BFA),
                      label: 'My Purchases',
                      subtitle: 'Workflows you have bought',
                      onTap: () => context.go('/purchases'),
                    ),
                    const SizedBox(height: 12),
                    _GlassMenuItem(
                      icon: Icons.rocket_launch_outlined,
                      iconColor: const Color(0xFF4DDCC6),
                      label: 'My Deployments',
                      subtitle: 'Active and past deployments',
                      onTap: () => context.push('/deployments'),
                    ),

                    // Seller section
                    const SizedBox(height: 12),
                    if (user.role == UserRole.seller)
                      _GlassMenuItem(
                        icon: Icons.storefront_outlined,
                        iconColor: const Color(0xFFFFAFD3),
                        label: 'Seller Dashboard',
                        subtitle: 'Manage your listings',
                        onTap: () => context.push('/seller'),
                      ),
                    if (user.role == UserRole.buyer)
                      _GlassMenuItem(
                        icon: Icons.storefront_outlined,
                        iconColor: const Color(0xFFFFAFD3),
                        label: 'Become a Seller',
                        subtitle: 'Start selling your workflows',
                        onTap: () => context.push('/seller/onboarding'),
                      ),

                    // Dark mode
                    const SizedBox(height: 12),
                    _GlassMenuItemSwitch(
                      icon: Icons.dark_mode_outlined,
                      iconColor: const Color(0xFFCEBDFF),
                      label: 'Dark Mode',
                      subtitle: 'Toggle app theme',
                      value: themeMode == ThemeMode.dark,
                      onChanged: (_) =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),

                    // Support
                    const SizedBox(height: 12),
                    _GlassMenuItem(
                      icon: Icons.help_outline,
                      iconColor: const Color(0xFFCAC4D4),
                      label: 'Help Center',
                      subtitle: 'Get support and answers',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _GlassMenuItem(
                      icon: Icons.description_outlined,
                      iconColor: const Color(0xFFCAC4D4),
                      label: 'Terms of Service',
                      subtitle: 'Review our terms',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _GlassMenuItem(
                      icon: Icons.shield_outlined,
                      iconColor: const Color(0xFFCAC4D4),
                      label: 'Privacy Policy',
                      subtitle: 'How we use your data',
                      onTap: () {},
                    ),

                    const SizedBox(height: 28),

                    // Logout button
                    GestureDetector(
                      onTap: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) context.go('/login');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF93000A),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF93000A)
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout,
                                color: Color(0xFFFFDAD6), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFDAD6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'FlowMarket v1.0.0',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.2),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final User user;
  const _ProfileHero({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with gradient ring
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Color(0xFF101415),
              shape: BoxShape.circle,
            ),
            child: AvatarWidget(
              name: user.fullName,
              imageUrl: user.avatarUrl,
              size: 90,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.role == UserRole.seller
              ? 'VERIFIED SELLER'
              : 'PREMIUM COLLECTOR',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: Color(0xFFCEBDFF),
          ),
        ),
      ],
    );
  }
}

class _GlassMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final String? badge;
  final VoidCallback? onTap;

  const _GlassMenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
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
                          fontSize: 11,
                          color: const Color(0xFFCAC4D4).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA78BFA),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF21005E),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassMenuItemSwitch extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _GlassMenuItemSwitch({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
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
                        fontSize: 11,
                        color: const Color(0xFFCAC4D4).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeTrackColor: const Color(0xFF8B5CF6),
                thumbColor: WidgetStateProperty.resolveWith(
                  (s) => s.contains(WidgetState.selected) ? const Color(0xFFCEBDFF) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
