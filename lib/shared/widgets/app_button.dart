import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_radius.dart';

enum AppButtonVariant { primary, outlined, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppButtonVariant.primary => _buildPrimary(context),
      AppButtonVariant.outlined => _buildOutlined(context),
      AppButtonVariant.text => _buildText(context),
      AppButtonVariant.danger => _buildDanger(context),
    };

    if (fullWidth) {
      return SizedBox(width: double.infinity, height: height ?? 50, child: button);
    }
    return button;
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.labelLarge),
        ],
      );
    }
    return Text(label, style: AppTypography.labelLarge);
  }

  Widget _buildPrimary(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        elevation: 0,
      ),
      child: _buildChild(Colors.white),
    );
  }

  Widget _buildOutlined(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.borderDarkMode
              : AppColors.border,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
      child: _buildChild(AppColors.textPrimary),
    );
  }

  Widget _buildText(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildChild(AppColors.primary),
    );
  }

  Widget _buildDanger(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        elevation: 0,
      ),
      child: _buildChild(Colors.white),
    );
  }
}
