import 'package:flutter/material.dart';
import '../../core/constants/app_typography.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? leading;
  final Widget? titleWidget;

  const AppBarCustom({
    super.key,
    this.title,
    this.actions,
    this.showBack = true,
    this.leading,
    this.titleWidget,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: leading ?? (showBack ? const BackButton() : null),
      automaticallyImplyLeading: false,
      title: titleWidget ??
          Text(
            title ?? '',
            style: AppTypography.h3,
          ),
      actions: actions,
    );
  }
}
