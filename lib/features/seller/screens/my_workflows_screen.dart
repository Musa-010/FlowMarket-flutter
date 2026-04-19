import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/seller_provider.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/seller_workflow_tile.dart';

class MyWorkflowsScreen extends ConsumerWidget {
  const MyWorkflowsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowsAsync = ref.watch(sellerWorkflowsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Workflows')),
      body: workflowsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load workflows',
            style:
                AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
        data: (workflows) {
          if (workflows.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.folder_open_outlined,
              title: 'No workflows yet',
              subtitle: 'Upload your first workflow to start selling',
              actionLabel: 'Upload Workflow',
              onAction: () => context.push('/seller/upload'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workflows.length,
            itemBuilder: (context, index) {
              return SellerWorkflowTile(workflow: workflows[index]);
            },
          );
        },
      ),
    );
  }
}
