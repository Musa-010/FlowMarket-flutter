import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/deployment/deployment_model.dart';
import '../../../providers/deployment_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../widgets/deployment_status_badge.dart';
import '../widgets/execution_log_tile.dart';

class DeploymentDetailScreen extends ConsumerWidget {
  final String id;

  const DeploymentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(deploymentDetailProvider(id));

    return detailAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(deploymentDetailProvider(id)),
        ),
      ),
      data: (deployment) => Scaffold(
        appBar: AppBar(
          title: Text(
            deployment.workflow?.title ?? 'Deployment',
            style: AppTypography.h3,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: DeploymentStatusBadge(status: deployment.status),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(context, ref, deployment),
              const SizedBox(height: AppSpacing.xxl),
              _buildExecutionHistory(ref),
              const SizedBox(height: AppSpacing.xxl),
              _buildConfigSection(context, deployment),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    WidgetRef ref,
    Deployment deployment,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeploymentStatusBadge(status: deployment.status),
          const SizedBox(height: AppSpacing.md),
          if (deployment.status == DeploymentStatus.active &&
              deployment.createdAt != null)
            Text(
              'Running since: ${Formatters.date(deployment.createdAt!)}',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          const SizedBox(height: 4),
          Text(
            'Total executions: ${Formatters.compactNumber(deployment.totalExecutions)}',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Last run: ${deployment.lastRunAt != null ? Formatters.timeAgo(deployment.lastRunAt!) : 'Never'}',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              if (deployment.status == DeploymentStatus.active)
                AppButton(
                  label: 'Pause',
                  icon: Icons.pause_rounded,
                  variant: AppButtonVariant.outlined,
                  fullWidth: false,
                  onPressed: () => ref
                      .read(deploymentsProvider.notifier)
                      .pauseDeployment(deployment.id),
                )
              else if (deployment.status == DeploymentStatus.paused ||
                  deployment.status == DeploymentStatus.failed)
                AppButton(
                  label: 'Resume',
                  icon: Icons.play_arrow_rounded,
                  variant: AppButtonVariant.primary,
                  fullWidth: false,
                  onPressed: () => ref
                      .read(deploymentsProvider.notifier)
                      .resumeDeployment(deployment.id),
                ),
              const Spacer(),
              AppButton(
                label: 'Stop',
                variant: AppButtonVariant.danger,
                fullWidth: false,
                icon: Icons.stop_rounded,
                onPressed: () {
                  // TODO: implement stop deployment
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionHistory(WidgetRef ref) {
    final logsAsync = ref.watch(deploymentLogsProvider(id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Executions', style: AppTypography.h4),
        const SizedBox(height: AppSpacing.md),
        logsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Text(
            'Failed to load logs',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.error),
          ),
          data: (logs) {
            if (logs.isEmpty) {
              return Text(
                'No executions yet',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textTertiary),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (context, index) =>
                  ExecutionLogTile(log: logs[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildConfigSection(BuildContext context, Deployment deployment) {
    final configEntries = deployment.config.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Configuration', style: AppTypography.h4),
        const SizedBox(height: AppSpacing.md),
        if (configEntries.isNotEmpty) ...[
          const Text(
            'Connected Accounts',
            style: AppTypography.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...configEntries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text(
                    '${entry.key}: ',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  Expanded(
                    child: Text(
                      '${entry.value}',
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else
          Text(
            'No configuration set',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textTertiary),
          ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Update Config',
          variant: AppButtonVariant.outlined,
          onPressed: () => context.push('/deployments/$id/configure'),
        ),
      ],
    );
  }
}
