import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/glass_widgets.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  late List<Map<String, dynamic>> _notifications;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _notifications = [
      {
        'title': 'Workflow Purchased!',
        'body': 'You bought Email Follow-up Automation',
        'type': 'purchase',
        'timestamp': now.subtract(const Duration(minutes: 5)),
        'isRead': false,
      },
      {
        'title': 'Deployment Active',
        'body': 'Your CRM Sync workflow is now running',
        'type': 'deployment',
        'timestamp': now.subtract(const Duration(hours: 1)),
        'isRead': false,
      },
      {
        'title': 'New Review',
        'body': 'Someone left a 5-star review on your workflow',
        'type': 'review',
        'timestamp': now.subtract(const Duration(hours: 3)),
        'isRead': true,
      },
      {
        'title': 'Payment Received',
        'body': 'You earned \$12.99 from Lead Scoring Pipeline',
        'type': 'purchase',
        'timestamp': now.subtract(const Duration(hours: 8)),
        'isRead': false,
      },
      {
        'title': 'Deployment Failed',
        'body': 'Invoice Generator workflow encountered an error',
        'type': 'deployment',
        'timestamp': now.subtract(const Duration(hours: 20)),
        'isRead': true,
      },
      {
        'title': 'Welcome to FlowMarket!',
        'body': 'Start browsing automations',
        'type': 'system',
        'timestamp': now.subtract(const Duration(days: 1)),
        'isRead': true,
      },
      {
        'title': 'Review Reminder',
        'body': 'Rate your recently purchased Slack Notifier workflow',
        'type': 'review',
        'timestamp': now.subtract(const Duration(days: 2)),
        'isRead': true,
      },
      {
        'title': 'System Maintenance',
        'body': 'Scheduled maintenance on April 15 from 2-4 AM UTC',
        'type': 'system',
        'timestamp': now.subtract(const Duration(days: 3)),
        'isRead': true,
      },
    ];
  }

  String _sectionForDate(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == yesterday) return 'Yesterday';
    return 'This Week';
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n['isRead'] = true;
      }
    });
  }

  void _dismiss(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'All') return _notifications;
    final map = {
      'Sales': 'purchase',
      'System': 'system',
      'Deployments': 'deployment',
    };
    final typeKey = map[_filter] ?? '';
    return _notifications
        .where((n) => n['type'] == typeKey)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
                    padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Color(0xFFCEBDFF)),
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 40, minHeight: 40),
                        ),
                        Expanded(
                          child: GradientText(
                            'FlowMarket',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _markAllRead,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                  color:
                                      Colors.white.withValues(alpha: 0.12)),
                            ),
                            child: Text(
                              'Mark all read',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFCEBDFF)
                                    .withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Activity',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stay updated on your workflows, sales, and deployments.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.45),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['All', 'Sales', 'System', 'Deployments']
                            .map((f) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _filter = f),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _filter == f
                                            ? const Color(0xFF8B5CF6)
                                                .withValues(alpha: 0.25)
                                            : Colors.white
                                                .withValues(alpha: 0.05),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: _filter == f
                                              ? const Color(0xFF8B5CF6)
                                                  .withValues(alpha: 0.5)
                                              : Colors.white
                                                  .withValues(alpha: 0.1),
                                        ),
                                      ),
                                      child: Text(
                                        f,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _filter == f
                                              ? const Color(0xFFCEBDFF)
                                              : Colors.white
                                                  .withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (filtered.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 48,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No notifications',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      // Grouped notifications
                      ..._buildGrouped(filtered),

                      const SizedBox(height: 24),

                      // Promo card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF4DDCC6)
                                      .withValues(alpha: 0.12),
                                  const Color(0xFF8B5CF6)
                                      .withValues(alpha: 0.12),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFF4DDCC6)
                                      .withValues(alpha: 0.25)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4DDCC6)
                                        .withValues(alpha: 0.15),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome_outlined,
                                    color: Color(0xFF4DDCC6),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Explore New Workflows',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '50+ automations added this week',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: Colors.white
                                              .withValues(alpha: 0.45),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      context.go('/marketplace'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4DDCC6)
                                          .withValues(alpha: 0.2),
                                      borderRadius:
                                          BorderRadius.circular(999),
                                      border: Border.all(
                                          color: const Color(0xFF4DDCC6)
                                              .withValues(alpha: 0.4)),
                                    ),
                                    child: const Text(
                                      'Browse',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF4DDCC6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGrouped(List<Map<String, dynamic>> items) {
    final widgets = <Widget>[];
    String? lastSection;

    for (int i = 0; i < items.length; i++) {
      final n = items[i];
      final section = _sectionForDate(n['timestamp'] as DateTime);

      if (section != lastSection) {
        if (i > 0) widgets.add(const SizedBox(height: 8));
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            section.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
        ));
        lastSection = section;
      }

      widgets.add(_NotificationTile(
        title: n['title'] as String,
        body: n['body'] as String,
        type: n['type'] as String,
        timestamp: n['timestamp'] as DateTime,
        isRead: n['isRead'] as bool,
        onTap: () => setState(() => n['isRead'] = true),
        onDismiss: () {
          final realIdx = _notifications.indexOf(n);
          if (realIdx >= 0) _dismiss(realIdx);
        },
      ));
    }

    return widgets;
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String type;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.onTap,
    required this.onDismiss,
  });

  IconData get _icon {
    switch (type) {
      case 'purchase':
        return Icons.shopping_bag_outlined;
      case 'deployment':
        return Icons.rocket_launch_outlined;
      case 'review':
        return Icons.star_outline_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Color get _color {
    switch (type) {
      case 'purchase':
        return const Color(0xFF4DDCC6);
      case 'deployment':
        return const Color(0xFF8B5CF6);
      case 'review':
        return const Color(0xFFFFAFD3);
      default:
        return const Color(0xFFCEBDFF);
    }
  }

  String _timeAgo() {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('$title$timestamp'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete_outline,
            color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead
                ? Colors.white.withValues(alpha: 0.03)
                : _color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead
                  ? Colors.white.withValues(alpha: 0.07)
                  : _color.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, color: _color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          _timeAgo(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.5),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: _color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
