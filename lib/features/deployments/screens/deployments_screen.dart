import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../models/deployment/deployment_model.dart';
import '../../../providers/deployment_provider.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/deployment_card.dart';

class DeploymentsScreen extends ConsumerWidget {
  const DeploymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Deployments', style: AppTypography.h2),
        centerTitle: false,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              labelStyle: AppTypography.labelLarge,
              unselectedLabelStyle: AppTypography.labelMedium,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Active'),
                Tab(text: 'Paused / Failed'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _DeploymentTab(
                    filter: null,
                  ),
                  _DeploymentTab(
                    filter: (d) => d.status == DeploymentStatus.active,
                  ),
                  _DeploymentTab(
                    filter: (d) =>
                        d.status == DeploymentStatus.paused ||
                        d.status == DeploymentStatus.failed,
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

class _DeploymentTab extends ConsumerWidget {
  final bool Function(Deployment)? filter;

  const _DeploymentTab({this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deploymentsAsync = ref.watch(deploymentsProvider);

    return deploymentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => AppErrorWidget(
        message: error.toString(),
        onRetry: () => ref.read(deploymentsProvider.notifier).refresh(),
      ),
      data: (deployments) {
        final filtered =
            filter != null ? deployments.where(filter!).toList() : deployments;

        if (filtered.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.rocket_launch_outlined,
            title: 'No deployments yet',
            subtitle: 'Deploy a workflow to get started.',
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(deploymentsProvider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final deployment = filtered[index];
              return DeploymentCard(
                deployment: deployment,
                onPauseResume: () {
                  final notifier = ref.read(deploymentsProvider.notifier);
                  if (deployment.status == DeploymentStatus.active) {
                    notifier.pauseDeployment(deployment.id);
                  } else {
                    notifier.resumeDeployment(deployment.id);
                  }
                },
                onLogs: () =>
                    context.push('/deployments/${deployment.id}'),
                onSettings: () =>
                    context.push('/deployments/${deployment.id}/configure'),
              );
            },
          ),
        );
      },
    );
  }
}
