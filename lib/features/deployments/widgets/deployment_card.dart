import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../models/deployment/deployment_model.dart';

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

  Color get _statusColor {
    switch (deployment.status) {
      case DeploymentStatus.active:
        return const Color(0xFF4DDCC6);
      case DeploymentStatus.failed:
        return const Color(0xFFFFB4AB);
      case DeploymentStatus.paused:
        return const Color(0xFFFFAFD3);
      default:
        return const Color(0xFFCAC4D4);
    }
  }

  String get _statusLabel {
    switch (deployment.status) {
      case DeploymentStatus.active:
        return 'Running';
      case DeploymentStatus.failed:
        return 'Failed';
      case DeploymentStatus.paused:
        return 'Paused';
      default:
        return 'Unknown';
    }
  }

  String get _typeLabel {
    final title = deployment.workflow?.title ?? '';
    if (title.toLowerCase().contains('database') ||
        title.toLowerCase().contains('db')) return 'DATABASE SYNC';
    if (title.toLowerCase().contains('stream') ||
        title.toLowerCase().contains('gateway')) return 'STREAM GATEWAY';
    if (title.toLowerCase().contains('asset') ||
        title.toLowerCase().contains('pipeline')) return 'ASSET PIPELINE';
    return 'COMPUTING NODE';
  }

  String get _uptime {
    if (deployment.createdAt == null) return '—';
    final diff = DateTime.now().difference(deployment.createdAt!);
    final days = diff.inDays;
    final hours = diff.inHours.remainder(24);
    final mins = diff.inMinutes.remainder(60);
    return '${days}d ${hours.toString().padLeft(2, '0')}h ${mins.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    final isFailed = deployment.status == DeploymentStatus.failed;
    final isSuccess = deployment.status == DeploymentStatus.stopped;

    return GestureDetector(
      onTap: () => context.push('/deployments/${deployment.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFailed
                    ? const Color(0xFFFFB4AB).withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: type + status badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _typeLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: _statusColor.withValues(alpha: 0.7),
                      ),
                    ),
                    _StatusPill(
                      label: _statusLabel,
                      color: _statusColor,
                      pulse: deployment.status == DeploymentStatus.active,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Name
                Text(
                  deployment.workflow?.title ?? 'Workflow',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // Error panel for failed
                if (isFailed) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB4AB).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFB4AB).withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 14,
                          color: Color(0xFFFFB4AB),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Last execution failed. Check logs for details.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: const Color(0xFFFFB4AB)
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ] else if (!isSuccess) ...[
                  // Uptime + executions grid
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCell(
                          label: 'UPTIME',
                          value: _uptime,
                        ),
                      ),
                      Expanded(
                        child: _InfoCell(
                          label: 'EXECUTIONS',
                          value: Formatters.compactNumber(
                              deployment.totalExecutions),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ] else ...[
                  // Success: duration + last run
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCell(
                          label: 'LAST RUN',
                          value: deployment.lastRunAt != null
                              ? Formatters.timeAgo(deployment.lastRunAt!)
                              : '—',
                        ),
                      ),
                      Expanded(
                        child: _InfoCell(
                          label: 'EXECUTIONS',
                          value: Formatters.compactNumber(
                              deployment.totalExecutions),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],

                // Action buttons
                if (isFailed)
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Restart Deployment',
                          color: const Color(0xFFFFB4AB),
                          textColor: const Color(0xFF690005),
                          onTap: onPauseResume,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        label: 'Report',
                        glass: true,
                        onTap: onLogs,
                      ),
                    ],
                  )
                else if (isSuccess)
                  _ActionButton(
                    label: 'Review Output',
                    glass: true,
                    fullWidth: true,
                    onTap: onLogs,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Manage',
                          white: true,
                          onTap: onSettings,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        label: 'Logs',
                        glass: true,
                        onTap: onLogs,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final bool pulse;

  const _StatusPill({
    required this.label,
    required this.color,
    this.pulse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool glass;
  final bool white;
  final bool fullWidth;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    this.glass = false,
    this.white = false,
    this.fullWidth = false,
    this.color,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: white
              ? Colors.white
              : color != null
                  ? color
                  : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: glass
              ? Border.all(color: Colors.white.withValues(alpha: 0.15))
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: white
                  ? const Color(0xFF101415)
                  : textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
    return child;
  }
}
