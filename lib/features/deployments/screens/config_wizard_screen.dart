import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/deployment_repository.dart';
import '../../../shared/widgets/glass_widgets.dart';

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
  bool _autoScaling = true;

  final _emailController = TextEditingController();
  final _appPasswordController = TextEditingController();
  final _spreadsheetUrlController = TextEditingController();
  final _sheetTabController = TextEditingController();
  final _followUpDelayController = TextEditingController();
  final _maxEmailsController = TextEditingController();

  // Key-value variable pairs for step 2
  final List<Map<String, TextEditingController>> _variables = [
    {
      'key': TextEditingController(text: 'API_ENDPOINT'),
      'value': TextEditingController(text: ''),
    },
  ];
  final List<bool> _obscured = [false];

  static const _totalSteps = 4;
  static const _stepLabels = [
    'Connect Email',
    'Connect Spreadsheet',
    'Environment Variables',
    'Review & Deploy',
  ];

  double get _progress => (_currentStep + 1) / _totalSteps;

  @override
  void dispose() {
    _emailController.dispose();
    _appPasswordController.dispose();
    _spreadsheetUrlController.dispose();
    _sheetTabController.dispose();
    _followUpDelayController.dispose();
    _maxEmailsController.dispose();
    for (final pair in _variables) {
      pair['key']!.dispose();
      pair['value']!.dispose();
    }
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
        'autoScaling': _autoScaling,
        for (final pair in _variables)
          if (pair['key']!.text.isNotEmpty)
            pair['key']!.text: pair['value']!.text,
      };

      await ref
          .read(deploymentRepositoryProvider)
          .configureDeployment(widget.deploymentId, config);

      if (mounted) context.pop();
    } catch (_) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isDeploying = false);
    }
  }

  void _addVariable() {
    setState(() {
      _variables.add({
        'key': TextEditingController(),
        'value': TextEditingController(),
      });
      _obscured.add(false);
    });
  }

  void _removeVariable(int index) {
    setState(() {
      _variables[index]['key']!.dispose();
      _variables[index]['value']!.dispose();
      _variables.removeAt(index);
      _obscured.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bubble_chart_outlined,
                            color: Color(0xFFCEBDFF), size: 20),
                        const SizedBox(width: 8),
                        GradientText(
                          'FlowMarket',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.notifications_outlined,
                            color:
                                const Color(0xFFCEBDFF).withValues(alpha: 0.8)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: [
                          // Progress card
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.1)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'STEP ${(_currentStep + 1).toString().padLeft(2, '0')}',
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1.5,
                                                  color: Color(0xFFCEBDFF),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _stepLabels[_currentStep],
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  letterSpacing: -0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'COMPLETION',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1.5,
                                                color: Colors.white
                                                    .withValues(alpha: 0.4),
                                              ),
                                            ),
                                            Text(
                                              '${(_progress * 100).round()}%',
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: LinearProgressIndicator(
                                        value: _progress,
                                        backgroundColor:
                                            Colors.white.withValues(alpha: 0.08),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF4DDCC6),
                                        ),
                                        minHeight: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Step content
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.08)),
                                ),
                                child: _buildStepContent(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Footer controls
                          Row(
                            children: [
                              // Back
                              GestureDetector(
                                onTap: _currentStep > 0
                                    ? () => setState(() => _currentStep--)
                                    : () => context.pop(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 15, sigmaY: 15),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.06),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Back',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),

                              // Save Draft
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'Save\nDraft',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                              ),

                              // Next / Deploy
                              GestureDetector(
                                onTap: _isDeploying
                                    ? null
                                    : () {
                                        if (_currentStep < _totalSteps - 1) {
                                          setState(() => _currentStep++);
                                        } else {
                                          _onDeploy();
                                        }
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCEBDFF),
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF8B5CF6)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: _isDeploying
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFF21005E),
                                          ),
                                        )
                                      : Text(
                                          _currentStep == _totalSteps - 1
                                              ? 'Deploy'
                                              : 'Next Step',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF21005E),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Helper text
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 13,
                                  color: Colors.white.withValues(alpha: 0.3)),
                              const SizedBox(width: 6),
                              Text(
                                'Your progress is automatically saved to the cloud.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
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
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    return switch (_currentStep) {
      0 => _buildEmailStep(),
      1 => _buildSpreadsheetStep(),
      2 => _buildEnvVarsStep(),
      3 => _buildReviewStep(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.email_outlined,
          title: 'Connect Email',
          subtitle: 'Authenticate your email account for workflow execution.',
        ),
        const SizedBox(height: 20),
        _GlassInput(
          controller: _emailController,
          label: 'EMAIL ADDRESS',
          hint: 'you@example.com',
          icon: Icons.alternate_email,
        ),
        const SizedBox(height: 14),
        _GlassInput(
          controller: _appPasswordController,
          label: 'APP PASSWORD',
          hint: 'Enter your app password',
          icon: Icons.lock_outline,
          obscure: true,
        ),
      ],
    );
  }

  Widget _buildSpreadsheetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.table_chart_outlined,
          title: 'Connect Spreadsheet',
          subtitle: 'Link your Google Sheets data source.',
        ),
        const SizedBox(height: 20),
        _GlassInput(
          controller: _spreadsheetUrlController,
          label: 'SPREADSHEET URL',
          hint: 'https://docs.google.com/spreadsheets/d/...',
          icon: Icons.link_outlined,
        ),
        const SizedBox(height: 14),
        _GlassInput(
          controller: _sheetTabController,
          label: 'SHEET TAB NAME',
          hint: 'Sheet1',
          icon: Icons.tab_outlined,
        ),
      ],
    );
  }

  Widget _buildEnvVarsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.terminal_outlined,
          title: 'Runtime Config',
          subtitle:
              'Define the keys and values your workflow requires during execution. Use encrypted secrets for sensitive data.',
        ),
        const SizedBox(height: 20),

        // Cluster namespace
        _GlassInput(
          controller: TextEditingController(text: 'production-alpha-09'),
          label: 'CLUSTER NAMESPACE',
          hint: 'production-alpha-09',
          icon: Icons.hub_outlined,
          readOnly: true,
        ),
        const SizedBox(height: 20),

        // Variables header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'VARIABLES',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            GestureDetector(
              onTap: _addVariable,
              child: const Text(
                '+ ADD NEW',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFCEBDFF),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Key-value pairs
        ...List.generate(_variables.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                _GlassInput(
                  controller: _variables[i]['key']!,
                  label: '',
                  hint: 'KEY_NAME',
                  icon: null,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _GlassInput(
                        controller: _variables[i]['value']!,
                        label: '',
                        hint: 'VALUE',
                        icon: null,
                        obscure: _obscured[i],
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _obscured[i] = !_obscured[i]),
                          child: Icon(
                            _obscured[i]
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeVariable(i),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB4AB).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Color(0xFFFFB4AB),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 8),

        // Auto-scaling toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Icon(Icons.settings_ethernet,
                  size: 20, color: Colors.white.withValues(alpha: 0.5)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enable Auto-Scaling',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Dynamic resource allocation based on load',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _autoScaling,
                onChanged: (v) => setState(() => _autoScaling = v),
                activeTrackColor: const Color(0xFF8B5CF6),
                thumbColor: WidgetStateProperty.resolveWith(
                  (s) => s.contains(WidgetState.selected) ? const Color(0xFFCEBDFF) : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.rocket_launch_outlined,
          title: 'Review & Deploy',
          subtitle: 'Confirm your configuration before going live.',
        ),
        const SizedBox(height: 20),
        _ReviewEntry(label: 'Email', value: _emailController.text),
        _ReviewEntry(
            label: 'Spreadsheet', value: _spreadsheetUrlController.text),
        _ReviewEntry(label: 'Sheet Tab', value: _sheetTabController.text),
        _ReviewEntry(
            label: 'Follow-up delay',
            value: '${_followUpDelayController.text} hours'),
        _ReviewEntry(
            label: 'Max emails/day', value: _maxEmailsController.text),
        _ReviewEntry(
            label: 'Send weekends', value: _sendOnWeekends ? 'Yes' : 'No'),
        _ReviewEntry(
            label: 'Auto-scaling', value: _autoScaling ? 'Enabled' : 'Off'),
        if (_variables.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'VARIABLES',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 6),
          ..._variables.map((pair) => _ReviewEntry(
                label: pair['key']!.text.isEmpty ? '—' : pair['key']!.text,
                value: pair['value']!.text.isEmpty ? '—' : '••••••',
              )),
        ],
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF4DDCC6).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFF4DDCC6).withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline,
                  size: 14, color: Color(0xFF4DDCC6)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your credentials are encrypted and stored securely.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: const Color(0xFF4DDCC6).withValues(alpha: 0.8),
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF4DDCC6).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF4DDCC6), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final bool obscure;
  final bool readOnly;
  final Widget? suffixIcon;

  const _GlassInput({
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.obscure = false,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
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
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            readOnly: readOnly,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.white,
            ),
            cursorColor: const Color(0xFFCEBDFF),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              prefixIcon: icon != null
                  ? Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.4))
                  : null,
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 36),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 14, horizontal: 18),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewEntry extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewEntry({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          Flexible(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
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
