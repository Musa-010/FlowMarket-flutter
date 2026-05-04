import 'dart:math';

import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            listenable: _controller,
            builder: (context, child) {
              final offset = index * 200 / 1200;
              final value = (_controller.value + offset) % 1.0;
              final dy = -4 * sin(value * pi);
              return Transform.translate(
                offset: Offset(0, dy),
                child: child,
              );
            },
            child: Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
              decoration: const BoxDecoration(
                color: Color(0xFFA78BFA),
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
