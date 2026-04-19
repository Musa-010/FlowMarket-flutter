import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../marketplace/widgets/category_chip.dart';
import '../widgets/upload_step_indicator.dart';

class UploadWorkflowScreen extends ConsumerStatefulWidget {
  const UploadWorkflowScreen({super.key});

  @override
  ConsumerState<UploadWorkflowScreen> createState() =>
      _UploadWorkflowScreenState();
}

class _UploadWorkflowScreenState extends ConsumerState<UploadWorkflowScreen> {
  int _currentStep = 0;

  // Step 0 controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  WorkflowCategory? _selectedCategory;
  WorkflowPlatform _selectedPlatform = WorkflowPlatform.n8n;
  WorkflowDifficulty _selectedDifficulty = WorkflowDifficulty.beginner;
  final _tagsController = TextEditingController();

  // Step 1
  final _demoVideoController = TextEditingController();
  bool _jsonUploaded = false;

  // Step 2
  final _oneTimePriceController = TextEditingController();
  final _monthlyPriceController = TextEditingController();
  String? _setupTime;
  final Set<String> _selectedIntegrations = {};
  final List<TextEditingController> _stepControllers = [
    TextEditingController(),
  ];

  static const _integrations = [
    'Gmail',
    'Slack',
    'Notion',
    'Google Sheets',
    'Airtable',
    'HubSpot',
    'Stripe',
    'Shopify',
    'Zapier',
    'Twilio',
    'OpenAI',
    'Discord',
  ];

  static const _setupTimes = [
    '5 minutes',
    '15 minutes',
    '30 minutes',
    '1 hour',
    '2+ hours',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _demoVideoController.dispose();
    _oneTimePriceController.dispose();
    _monthlyPriceController.dispose();
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _next() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workflow submitted for review!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Workflow')),
      body: Column(
        children: [
          UploadStepIndicator(
            currentStep: _currentStep,
            totalSteps: 4,
            stepLabels: const ['Info', 'Media', 'Pricing', 'Review'],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStepContent(),
            ),
          ),
          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: AppButton(
                      label: 'Back',
                      variant: AppButtonVariant.outlined,
                      onPressed: _back,
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: _currentStep == 3 ? 'Submit' : 'Next',
                    onPressed: _currentStep == 3 ? _submit : _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return switch (_currentStep) {
      0 => _buildBasicInfo(),
      1 => _buildMedia(),
      2 => _buildPricing(),
      3 => _buildReview(),
      _ => const SizedBox.shrink(),
    };
  }

  // --- Step 0: Basic Info ---
  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _titleController,
          label: 'Title',
          hint: 'e.g. Automated Lead Nurture Sequence',
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _descriptionController,
          label: 'Short Description',
          hint: 'Describe what this workflow does',
          maxLines: 3,
          maxLength: 160,
        ),
        const SizedBox(height: 16),
        Text('Category',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        DropdownButtonFormField<WorkflowCategory>(
          initialValue: _selectedCategory,
          decoration: const InputDecoration(hintText: 'Select a category'),
          items: WorkflowCategory.values
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(CategoryChip.labelFor(c)),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _selectedCategory = v),
        ),
        const SizedBox(height: 16),
        Text('Platform',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        SegmentedButton<WorkflowPlatform>(
          segments: const [
            ButtonSegment(value: WorkflowPlatform.n8n, label: Text('n8n')),
            ButtonSegment(value: WorkflowPlatform.make, label: Text('Make')),
            ButtonSegment(value: WorkflowPlatform.both, label: Text('Both')),
          ],
          selected: {_selectedPlatform},
          onSelectionChanged: (v) =>
              setState(() => _selectedPlatform = v.first),
        ),
        const SizedBox(height: 16),
        Text('Difficulty',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        SegmentedButton<WorkflowDifficulty>(
          segments: const [
            ButtonSegment(
                value: WorkflowDifficulty.beginner, label: Text('Beginner')),
            ButtonSegment(
                value: WorkflowDifficulty.intermediate,
                label: Text('Intermediate')),
            ButtonSegment(
                value: WorkflowDifficulty.advanced, label: Text('Advanced')),
          ],
          selected: {_selectedDifficulty},
          onSelectionChanged: (v) =>
              setState(() => _selectedDifficulty = v.first),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _tagsController,
          label: 'Tags',
          hint: 'Comma-separated tags',
        ),
      ],
    );
  }

  // --- Step 1: Media ---
  Widget _buildMedia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Workflow File',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _jsonUploaded = true);
          },
          icon: Icon(
            _jsonUploaded ? Icons.check_circle : Icons.upload_file,
            color: _jsonUploaded ? AppColors.accent : null,
          ),
          label: Text(_jsonUploaded ? 'workflow.json uploaded' : 'Upload JSON'),
        ),
        const SizedBox(height: 24),
        Text('Screenshots',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Row(
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: AppRadius.sm,
                  ),
                  child: const Icon(Icons.add_photo_alternate_outlined,
                      color: AppColors.textTertiary),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: _demoVideoController,
          label: 'Demo Video URL',
          hint: 'https://youtube.com/...',
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  // --- Step 2: Pricing ---
  Widget _buildPricing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Required Integrations',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _integrations.map((name) {
            final selected = _selectedIntegrations.contains(name);
            return FilterChip(
              label: Text(name),
              selected: selected,
              onSelected: (v) {
                setState(() {
                  if (v) {
                    _selectedIntegrations.add(name);
                  } else {
                    _selectedIntegrations.remove(name);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: _oneTimePriceController,
          label: 'One-Time Price (\$)',
          hint: '29',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _monthlyPriceController,
          label: 'Monthly Price (\$)',
          hint: '9',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Text('Estimated Setup Time',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _setupTime,
          decoration: const InputDecoration(hintText: 'Select setup time'),
          items: _setupTimes
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (v) => setState(() => _setupTime = v),
        ),
        const SizedBox(height: 24),
        Text('Setup Steps',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        ...List.generate(_stepControllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _stepControllers[i],
                    hint: 'Step ${i + 1}',
                  ),
                ),
                if (_stepControllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: AppColors.error),
                    onPressed: () {
                      setState(() {
                        _stepControllers[i].dispose();
                        _stepControllers.removeAt(i);
                      });
                    },
                  ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () {
            setState(() => _stepControllers.add(TextEditingController()));
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Step'),
        ),
      ],
    );
  }

  // --- Step 3: Review ---
  Widget _buildReview() {
    final stepsText = _stepControllers
        .map((c) => c.text)
        .where((t) => t.isNotEmpty)
        .join(' -> ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review Your Workflow', style: AppTypography.h3),
        const SizedBox(height: 16),
        _ReviewRow(label: 'Title', value: _titleController.text),
        _ReviewRow(label: 'Description', value: _descriptionController.text),
        _ReviewRow(
          label: 'Category',
          value: _selectedCategory != null
              ? CategoryChip.labelFor(_selectedCategory!)
              : 'Not selected',
        ),
        _ReviewRow(label: 'Platform', value: _selectedPlatform.name),
        _ReviewRow(label: 'Difficulty', value: _selectedDifficulty.name),
        _ReviewRow(label: 'Tags', value: _tagsController.text),
        _ReviewRow(
            label: 'JSON File', value: _jsonUploaded ? 'Uploaded' : 'None'),
        _ReviewRow(
          label: 'Demo Video',
          value: _demoVideoController.text.isEmpty
              ? 'None'
              : _demoVideoController.text,
        ),
        _ReviewRow(
          label: 'Integrations',
          value: _selectedIntegrations.isEmpty
              ? 'None'
              : _selectedIntegrations.join(', '),
        ),
        _ReviewRow(
          label: 'One-Time Price',
          value: _oneTimePriceController.text.isEmpty
              ? 'Free'
              : '\$${_oneTimePriceController.text}',
        ),
        _ReviewRow(
          label: 'Monthly Price',
          value: _monthlyPriceController.text.isEmpty
              ? 'None'
              : '\$${_monthlyPriceController.text}/mo',
        ),
        _ReviewRow(label: 'Setup Time', value: _setupTime ?? 'Not set'),
        _ReviewRow(
          label: 'Steps',
          value: stepsText.isEmpty ? 'None' : stepsText,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppRadius.md,
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your workflow will be reviewed by our team before going live. This usually takes 1-2 business days.',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTypography.labelMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
