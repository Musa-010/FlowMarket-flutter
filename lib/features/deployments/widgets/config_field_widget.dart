import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';

class ConfigFieldWidget extends StatelessWidget {
  final String label;
  final String? hint;
  final bool isObscured;
  final TextEditingController controller;
  final String? helpUrl;

  const ConfigFieldWidget({
    super.key,
    required this.label,
    this.hint,
    this.isObscured = false,
    required this.controller,
    this.helpUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium),
        const SizedBox(height: 6),
        AppTextField(
          controller: controller,
          hint: hint,
          obscureText: isObscured,
        ),
        if (helpUrl != null)
          TextButton.icon(
            onPressed: () => launchUrl(Uri.parse(helpUrl!)),
            icon: const Icon(Icons.link, size: 16),
            label: Text(
              'How to get this?',
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.primary),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(top: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
      ],
    );
  }
}
