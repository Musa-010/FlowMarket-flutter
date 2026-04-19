import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  late List<Map<String, dynamic>> _notifications;

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
    final dateOnly = DateTime(timestamp.year, timestamp.month, timestamp.day);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              'Mark all read',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'No notifications',
              subtitle: "You're all caught up!",
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final timestamp = notification['timestamp'] as DateTime;
                final section = _sectionForDate(timestamp);

                final bool showHeader = index == 0 ||
                    _sectionForDate(
                          _notifications[index - 1]['timestamp'] as DateTime,
                        ) !=
                        section;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.sm,
                        ),
                        child: Text(
                          section.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    NotificationTile(
                      title: notification['title'] as String,
                      body: notification['body'] as String,
                      type: notification['type'] as String,
                      timestamp: timestamp,
                      isRead: notification['isRead'] as bool,
                      onTap: () {
                        setState(() {
                          notification['isRead'] = true;
                        });
                      },
                      onDismiss: () => _dismiss(index),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
