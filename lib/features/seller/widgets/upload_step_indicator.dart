import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class UploadStepIndicator extends StatelessWidget {
  const UploadStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });

  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            return _StepCircle(
              stepIndex: stepIndex,
              currentStep: currentStep,
              label: stepLabels[stepIndex],
            );
          } else {
            final beforeStep = index ~/ 2;
            final isCompleted = beforeStep < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? AppColors.primary : AppColors.border,
              ),
            );
          }
        }),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.stepIndex,
    required this.currentStep,
    required this.label,
  });

  final int stepIndex;
  final int currentStep;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isCompleted = stepIndex < currentStep;
    final isCurrent = stepIndex == currentStep;
    final isActive = isCompleted || isCurrent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.transparent,
            border: isActive
                ? null
                : Border.all(color: AppColors.border, width: 2),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '${stepIndex + 1}',
                    style: AppTypography.labelMedium.copyWith(
                      color: isActive
                          ? Colors.white
                          : AppColors.textTertiary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isActive ? AppColors.primary : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
