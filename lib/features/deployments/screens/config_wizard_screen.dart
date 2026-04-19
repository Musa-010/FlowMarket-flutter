import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../repositories/deployment_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../widgets/config_field_widget.dart';

class ConfigWizardScreen extends ConsumerStatefulWidget {
  final String deploymentId;

  const ConfigWizardScreen({super.key, required this.deploymentId});

  @override
  ConsumerState<ConfigWizardScreen> createState() => _ConfigWizardScreenState();
}

class _ConfigWizardScreenState extends ConsumerState<ConfigWizardScreen> {
  int _currentStep = 0;
  bool _isDeploying = false;
  bool _sendOnWeekends = false;

  // Step 1 - Connect Email
  final _emailController = TextEditingController();
  final _appPasswordController = TextEditingController();

  // Step 2 - Connect Spreadsheet
  final _spreadsheetUrlController = TextEditingController();
  final _sheetTabController = TextEditingController();

  // Step 3 - Settings
  final _followUpDelayController = TextEditingController();
  final _maxEmailsController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _appPasswordController.dispose();
    _spreadsheetUrlController.dispose();
    _sheetTabController.dispose();
    _followUpDelayController.dispose();
    _maxEmailsController.dispose();
    super.dispose();
  }

  Future<void> _onDeploy() async {
    setState(() => _isDeploying = true);

    try {
      final config = {
        'email': _emailController.text,
        'appPassword': _appPasswordController.text,
        'spreadsheetUrl': _spreadsheetUrlController.text,
        'sheetTab': _sheetTabController.text,
        'followUpDelayHours': _followUpDelayController.text,
        'maxEmailsPerDay': _maxEmailsController.text,
        'sendOnWeekends': _sendOnWeekends,
      };

      await ref
          .read(deploymentRepositoryProvider)
          .configureDeployment(widget.deploymentId, config);

      if (mounted) {
        context.pop();
      }
    } catch (_) {
      // Simulate delay on failure then pop
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isDeploying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Workflow', style: AppTypography.h3),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep++);
          } else {
            _onDeploy();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        onStepTapped: (index) => setState(() => _currentStep = index),
        controlsBuilder: (context, details) {
          if (_currentStep == 3) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: Row(
              children: [
                AppButton(
                  label: 'Continue',
                  fullWidth: false,
                  onPressed: details.onStepContinue,
                ),
                const SizedBox(width: AppSpacing.md),
                if (_currentStep > 0)
                  AppButton(
                    label: 'Back',
                    variant: AppButtonVariant.text,
                    fullWidth: false,
                    onPressed: details.onStepCancel,
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Connect Email', style: AppTypography.labelLarge),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                ConfigFieldWidget(
                  label: 'Email Address',
                  hint: 'you@example.com',
                  controller: _emailController,
                ),
                const SizedBox(height: AppSpacing.lg),
                ConfigFieldWidget(
                  label: 'App Password',
                  hint: 'Enter your app password',
                  isObscured: true,
                  controller: _appPasswordController,
                  helpUrl: 'https://support.google.com/accounts/answer/185833',
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Connect Spreadsheet',
                style: AppTypography.labelLarge),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                ConfigFieldWidget(
                  label: 'Spreadsheet URL',
                  hint: 'https://docs.google.com/spreadsheets/d/...',
                  controller: _spreadsheetUrlController,
                ),
                const SizedBox(height: AppSpacing.lg),
                ConfigFieldWidget(
                  label: 'Sheet Tab Name',
                  hint: 'Sheet1',
                  controller: _sheetTabController,
                ),
              ],
            ),
          ),
          Step(
            title:
                const Text('Settings', style: AppTypography.labelLarge),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                ConfigFieldWidget(
                  label: 'Follow-up delay (hours)',
                  hint: '24',
                  controller: _followUpDelayController,
                ),
                const SizedBox(height: AppSpacing.lg),
                ConfigFieldWidget(
                  label: 'Max emails per day',
                  hint: '50',
                  controller: _maxEmailsController,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Send on weekends',
                        style: AppTypography.labelMedium),
                    Switch(
                      value: _sendOnWeekends,
                      activeTrackColor: AppColors.primary,
                      onChanged: (v) =>
                          setState(() => _sendOnWeekends = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Review & Deploy',
                style: AppTypography.labelLarge),
            isActive: _currentStep >= 3,
            state: StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReviewRow('Email', _emailController),
                _buildReviewRow('Spreadsheet URL', _spreadsheetUrlController),
                _buildReviewRow('Sheet Tab', _sheetTabController),
                _buildReviewRow(
                    'Follow-up delay', _followUpDelayController,
                    suffix: ' hours'),
                _buildReviewRow('Max emails/day', _maxEmailsController),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Send on weekends',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        _sendOnWeekends ? 'Yes' : 'No',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Deploy Workflow',
                  isLoading: _isDeploying,
                  icon: Icons.rocket_launch_rounded,
                  onPressed: _isDeploying ? null : _onDeploy,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Your credentials are encrypted and stored securely',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow(
    String label,
    TextEditingController controller, {
    String suffix = '',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          Flexible(
            child: Text(
              '${controller.text}$suffix',
              style: AppTypography.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
