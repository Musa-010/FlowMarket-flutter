import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/deployment/deployment_model.dart';
import 'deployment_status_badge.dart';

class DeploymentCard extends StatelessWidget {
  final Deployment deployment;
  final VoidCallback? onPauseResume;
  final VoidCallback? onLogs;
  final VoidCallback? onSettings;
  final VoidCallback? onStop;

  const DeploymentCard({
    super.key,
    required this.deployment,
    this.onPauseResume,
    this.onLogs,
    this.onSettings,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final previewImages = deployment.workflow?.previewImages ?? [];
    final thumbnailUrl = previewImages.isNotEmpty ? previewImages.first : null;

    return Dismissible(
      key: Key('deployment-${deployment.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadius.md,
        ),
        child: const Icon(Icons.stop_rounded, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        onStop?.call();
        return false;
      },
      child: GestureDetector(
        onTap: () => context.push('/deployments/${deployment.id}'),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadius.md,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.sm,
                    child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumbnailUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _buildPlaceholder(),
                            errorWidget: (_, __, ___) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deployment.workflow?.title ?? 'Workflow',
                          style: AppTypography.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        DeploymentStatusBadge(status: deployment.status),
                        const SizedBox(height: 4),
                        Text(
                          'Last run: ${deployment.lastRunAt != null ? Formatters.timeAgo(deployment.lastRunAt!) : 'Never'}',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          '${Formatters.compactNumber(deployment.totalExecutions)} executions',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildIconButton(
                    icon: deployment.status == DeploymentStatus.active
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    onTap: onPauseResume,
                  ),
                  _buildIconButton(
                    icon: Icons.article_outlined,
                    onTap: onLogs,
                  ),
                  _buildIconButton(
                    icon: Icons.settings_outlined,
                    onTap: onSettings,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.account_tree_outlined,
        color: AppColors.textTertiary,
        size: 24,
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        padding: EdgeInsets.zero,
        color: AppColors.textSecondary,
      ),
    );
  }
}
