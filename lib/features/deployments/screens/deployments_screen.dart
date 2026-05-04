import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/deployment/deployment_model.dart';
import '../../../providers/deployment_provider.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/glass_widgets.dart';
import '../widgets/deployment_card.dart';

class DeploymentsScreen extends ConsumerStatefulWidget {
  const DeploymentsScreen({super.key});

  @override
  ConsumerState<DeploymentsScreen> createState() => _DeploymentsScreenState();
}

class _DeploymentsScreenState extends ConsumerState<DeploymentsScreen> {
  int _tabIndex = 0; // 0 = Active, 1 = History

  @override
  Widget build(BuildContext context) {
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
                        const Icon(Icons.bubble_chart_outlined,
                            color: Color(0xFFCEBDFF), size: 20),
                        const SizedBox(width: 8),
                        GradientText(
                          'FlowMarket',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
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

            // Body
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Title + toggle
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deployments',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Pill toggle
                          GlassCard(
                            borderRadius: BorderRadius.circular(999),
                            padding: const EdgeInsets.all(4),
                            opacity: 0.06,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ToggleTab(
                                  label: 'Active',
                                  active: _tabIndex == 0,
                                  onTap: () =>
                                      setState(() => _tabIndex = 0),
                                ),
                                _ToggleTab(
                                  label: 'History',
                                  active: _tabIndex == 1,
                                  onTap: () =>
                                      setState(() => _tabIndex = 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Deployment list
                  _DeploymentList(
                    filter: _tabIndex == 0
                        ? (d) =>
                            d.status == DeploymentStatus.active ||
                            d.status == DeploymentStatus.paused ||
                            d.status == DeploymentStatus.failed
                        : (d) => d.status == DeploymentStatus.stopped,
                  ),

                  // End of feed decoration
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF3C1989)
                                        .withValues(alpha: 0.4),
                                    const Color(0xFF6A0045)
                                        .withValues(alpha: 0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'END OF DEPLOYMENT FEED',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeploymentList extends ConsumerWidget {
  final bool Function(Deployment) filter;

  const _DeploymentList({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deploymentsAsync = ref.watch(deploymentsProvider);

    return deploymentsAsync.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFCEBDFF),
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppErrorWidget(
            message: error.toString(),
            onRetry: () =>
                ref.read(deploymentsProvider.notifier).refresh(),
          ),
        ),
      ),
      data: (deployments) {
        final filtered = deployments.where(filter).toList();

        if (filtered.isEmpty) {
          return SliverToBoxAdapter(
            child: EmptyStateWidget(
              icon: Icons.rocket_launch_outlined,
              title: 'No deployments yet',
              subtitle: 'Deploy a workflow to get started.',
              actionLabel: 'Browse Marketplace',
              onAction: () => context.go('/marketplace'),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final deployment = filtered[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DeploymentCard(
                    deployment: deployment,
                    onPauseResume: () {
                      final notifier =
                          ref.read(deploymentsProvider.notifier);
                      if (deployment.status == DeploymentStatus.active) {
                        notifier.pauseDeployment(deployment.id);
                      } else {
                        notifier.resumeDeployment(deployment.id);
                      }
                    },
                    onLogs: () =>
                        context.push('/deployments/${deployment.id}'),
                    onSettings: () => context
                        .push('/deployments/${deployment.id}/configure'),
                  ),
                );
              },
              childCount: filtered.length,
            ),
          ),
        );
      },
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: active
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.2))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active
                ? const Color(0xFFCEBDFF)
                : const Color(0xFFCAC4D4).withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
