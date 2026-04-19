import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../models/workflow/workflow_model.dart';
import 'workflow_card.dart';

class RelatedWorkflowsRow extends StatelessWidget {
  const RelatedWorkflowsRow({super.key, required this.workflows});

  final List<Workflow> workflows;

  @override
  Widget build(BuildContext context) {
    if (workflows.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: workflows.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < workflows.length - 1 ? AppSpacing.md : 0,
            ),
            child: SizedBox(
              width: 180,
              child: WorkflowCard(
                workflow: workflows[index],
                isLarge: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
