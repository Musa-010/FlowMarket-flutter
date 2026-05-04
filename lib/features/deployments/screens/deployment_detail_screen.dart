import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../models/deployment/deployment_model.dart';
import '../../../providers/deployment_provider.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/glass_widgets.dart';

class DeploymentDetailScreen extends ConsumerWidget {
  final String id;

  const DeploymentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(deploymentDetailProvider(id));

    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: detailAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFCEBDFF),
              strokeWidth: 2,
            ),
          ),
          error: (error, _) => Column(
            children: [
              SafeArea(
                bottom: false,
                child: _GlassHeader(title: 'Deployment', onBack: () => context.pop()),
              ),
              Expanded(
                child: AppErrorWidget(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(deploymentDetailProvider(id)),
                ),
              ),
            ],
          ),
          data: (deployment) => _DeploymentDetailBody(
            deployment: deployment,
            deploymentId: id,
            ref: ref,
          ),
        ),
      ),
    );
  }
}

class _DeploymentDetailBody extends StatelessWidget {
  final Deployment deployment;
  final String deploymentId;
  final WidgetRef ref;

  const _DeploymentDetailBody({
    required this.deployment,
    required this.deploymentId,
    required this.ref,
  });

  String get _typeLabel {
    final title = deployment.workflow?.title ?? '';
    if (title.toLowerCase().contains('database') ||
        title.toLowerCase().contains('db')) { return 'DATABASE SYNC'; }
    if (title.toLowerCase().contains('stream') ||
        title.toLowerCase().contains('gateway')) { return 'STREAM GATEWAY'; }
    if (title.toLowerCase().contains('asset') ||
        title.toLowerCase().contains('pipeline')) { return 'ASSET PIPELINE'; }
    return 'COMPUTING NODE';
  }

  String get _versionLabel {
    final hash = deployment.id.substring(0, math.min(8, deployment.id.length)).toUpperCase();
    return 'PRODUCTION-$hash';
  }

  String get _uptime {
    if (deployment.createdAt == null) return '—';
    final diff = DateTime.now().difference(deployment.createdAt!);
    final days = diff.inDays;
    final hours = diff.inHours.remainder(24);
    return '${days}d ${hours}h';
  }

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
        return 'Active & Healthy';
      case DeploymentStatus.failed:
        return 'Failed';
      case DeploymentStatus.paused:
        return 'Paused';
      default:
        return deployment.status.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: _GlassHeader(
            title: deployment.workflow?.title ?? 'Deployment',
            onBack: () => context.pop(),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status card
                      _StatusCard(
                        versionLabel: _versionLabel,
                        typeLabel: _typeLabel,
                        workflowTitle: deployment.workflow?.title ?? 'Workflow',
                        statusLabel: _statusLabel,
                        statusColor: _statusColor,
                        uptime: _uptime,
                        isActive: deployment.status == DeploymentStatus.active,
                      ),
                      const SizedBox(height: 16),

                      // Action buttons row
                      _ActionButtonsRow(
                        deployment: deployment,
                        ref: ref,
                        onConfigure: () =>
                            context.push('/deployments/${deployment.id}/configure'),
                      ),
                      const SizedBox(height: 20),

                      // Bento metrics row
                      Row(
                        children: [
                          Expanded(
                            child: _MetricBento(
                              label: 'CPU USAGE',
                              value: '${(23 + deployment.totalExecutions % 40)}%',
                              barValue: 0.23 + (deployment.totalExecutions % 40) / 100,
                              color: const Color(0xFF4DDCC6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricBento(
                              label: 'MEMORY',
                              value: '${(512 + deployment.totalExecutions % 512)} MB',
                              barValue: 0.4 + (deployment.totalExecutions % 30) / 100,
                              color: const Color(0xFFCEBDFF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Network throughput card
                      _NetworkCard(
                        totalExecutions: deployment.totalExecutions,
                      ),
                      const SizedBox(height: 20),

                      // Execution logs
                      _LogsSection(deploymentId: deploymentId),
                      const SizedBox(height: 20),

                      // Configuration
                      _ConfigSection(
                        deployment: deployment,
                        onTap: () =>
                            context.push('/deployments/${deployment.id}/configure'),
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
    );
  }
}

class _GlassHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _GlassHeader({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 10, 20, 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFCEBDFF)),
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GlassCard(
                borderRadius: BorderRadius.circular(999),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                opacity: 0.06,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share_outlined,
                        size: 14, color: Colors.white.withValues(alpha: 0.6)),
                    const SizedBox(width: 6),
                    Text(
                      'Share',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String versionLabel;
  final String typeLabel;
  final String workflowTitle;
  final String statusLabel;
  final Color statusColor;
  final String uptime;
  final bool isActive;

  const _StatusCard({
    required this.versionLabel,
    required this.typeLabel,
    required this.workflowTitle,
    required this.statusLabel,
    required this.statusColor,
    required this.uptime,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Version badge + type
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      versionLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: Color(0xFFCEBDFF),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    typeLabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: statusColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Workflow name
              Text(
                workflowTitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Status row
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: statusColor.withValues(alpha: 0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '•',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$uptime uptime',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final Deployment deployment;
  final WidgetRef ref;
  final VoidCallback onConfigure;

  const _ActionButtonsRow({
    required this.deployment,
    required this.ref,
    required this.onConfigure,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = deployment.status == DeploymentStatus.active;
    final isPaused = deployment.status == DeploymentStatus.paused;
    final isFailed = deployment.status == DeploymentStatus.failed;

    return Row(
      children: [
        // Stop
        Expanded(
          child: _SquareActionButton(
            icon: Icons.stop_rounded,
            label: 'Stop',
            color: const Color(0xFFFFB4AB),
            bgColor: const Color(0xFFFFB4AB).withValues(alpha: 0.12),
            borderColor: const Color(0xFFFFB4AB).withValues(alpha: 0.25),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),

        // Restart / Resume
        Expanded(
          child: _SquareActionButton(
            icon: isFailed || isPaused
                ? Icons.play_arrow_rounded
                : Icons.refresh_rounded,
            label: isFailed || isPaused ? 'Resume' : 'Restart',
            color: const Color(0xFF4DDCC6),
            bgColor: const Color(0xFF4DDCC6).withValues(alpha: 0.12),
            borderColor: const Color(0xFF4DDCC6).withValues(alpha: 0.25),
            onTap: () {
              final notifier = ref.read(deploymentsProvider.notifier);
              if (isActive) {
                notifier.pauseDeployment(deployment.id);
              } else {
                notifier.resumeDeployment(deployment.id);
              }
            },
          ),
        ),
        const SizedBox(width: 10),

        // Update / Configure
        Expanded(
          child: _SquareActionButton(
            icon: Icons.tune_rounded,
            label: 'Update',
            color: const Color(0xFFCEBDFF),
            bgColor: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
            borderColor: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
            onTap: onConfigure,
          ),
        ),
      ],
    );
  }
}

class _SquareActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _SquareActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricBento extends StatelessWidget {
  final String label;
  final String value;
  final double barValue;
  final Color color;

  const _MetricBento({
    required this.label,
    required this.value,
    required this.barValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              // Bar chart visual
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(8, (i) {
                  final h = 8.0 + (math.sin(i * 0.8 + barValue * 10) * 10).abs() +
                      (i == 5 ? 16 : 0);
                  final isLast = i == 7;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: isLast ? 0 : 3),
                      child: Container(
                        height: h.clamp(6, 32),
                        decoration: BoxDecoration(
                          color: isLast
                              ? color
                              : color.withValues(alpha: 0.3 + i * 0.08),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkCard extends StatelessWidget {
  final int totalExecutions;

  const _NetworkCard({required this.totalExecutions});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NETWORK THROUGHPUT',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  Text(
                    '${(2.4 + totalExecutions * 0.01).toStringAsFixed(1)} MB/s',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFCEBDFF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Line graph approximation using bars
              SizedBox(
                height: 50,
                child: CustomPaint(
                  painter: _LinePainter(seed: totalExecutions),
                  size: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final int seed;
  const _LinePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[];
    const count = 20;
    for (int i = 0; i < count; i++) {
      final x = size.width * i / (count - 1);
      final y = size.height * 0.5 +
          math.sin(i * 0.5 + seed * 0.1) * size.height * 0.3 +
          math.cos(i * 0.9) * size.height * 0.15;
      points.add(Offset(x, y.clamp(4, size.height - 4)));
    }

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i].dy,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }

    // Fill gradient
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF8B5CF6).withValues(alpha: 0.3),
          const Color(0xFF8B5CF6).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final strokePaint = Paint()
      ..color = const Color(0xFFCEBDFF)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LogsSection extends ConsumerWidget {
  final String deploymentId;

  const _LogsSection({required this.deploymentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(deploymentLogsProvider(deploymentId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SYSTEM LOGS',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: Color(0xFFCEBDFF),
              ),
            ),
            Text(
              'LIVE',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                color: const Color(0xFF4DDCC6).withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: logsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(
                      color: Color(0xFFCEBDFF),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                error: (_, __) => Text(
                  'Failed to load logs',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: const Color(0xFFFFB4AB).withValues(alpha: 0.7),
                  ),
                ),
                data: (logs) {
                  if (logs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No executions yet',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: logs.map((log) => _LogEntry(log: log)).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogEntry extends StatelessWidget {
  final ExecutionLog log;

  const _LogEntry({required this.log});

  @override
  Widget build(BuildContext context) {
    final color = log.success ? const Color(0xFF4DDCC6) : const Color(0xFFFFB4AB);
    final prefix = log.success ? 'SUCCESS' : 'ERROR  ';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      prefix,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${log.durationMs}ms',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Formatters.timeAgo(log.executedAt ?? DateTime.now()),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
                if (!log.success && log.errorMessage != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    log.errorMessage!,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: const Color(0xFFFFB4AB).withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class _ConfigSection extends StatelessWidget {
  final Deployment deployment;
  final VoidCallback onTap;

  const _ConfigSection({required this.deployment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final configEntries = deployment.config.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONFIGURATION',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Color(0xFFCEBDFF),
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: [
                  if (configEntries.isEmpty)
                    _ConfigRow(
                      label: 'No configuration set',
                      value: 'Tap to configure',
                      icon: Icons.settings_outlined,
                      onTap: onTap,
                      showDivider: false,
                    )
                  else
                    ...configEntries.asMap().entries.map((e) {
                      final isLast = e.key == configEntries.length - 1;
                      return _ConfigRow(
                        label: e.value.key,
                        value: '${e.value.value}',
                        icon: Icons.link_outlined,
                        onTap: onTap,
                        showDivider: !isLast,
                      );
                    }),
                  _ConfigRow(
                    label: 'Update Configuration',
                    value: 'Modify settings',
                    icon: Icons.tune_rounded,
                    iconColor: const Color(0xFFCEBDFF),
                    onTap: onTap,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final bool showDivider;

  const _ConfigRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: iconColor ?? Colors.white.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              color: Colors.white.withValues(alpha: 0.06),
              indent: 44,
            ),
        ],
      ),
    );
  }
}
