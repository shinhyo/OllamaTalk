import 'package:flutter/material.dart';

class MaxWidthContainer extends StatelessWidget {
  static const double _maxWidth = 832;
  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 16;

  final _boxConstraints = const BoxConstraints(maxWidth: _maxWidth);

  final _defaultPadding = const EdgeInsets.symmetric(
    horizontal: _horizontalPadding,
    vertical: _verticalPadding,
  );

  final Widget child;
  final EdgeInsetsGeometry? padding;

  const MaxWidthContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          constraints: _boxConstraints,
          padding: padding ?? _defaultPadding,
          child: child,
        ),
      );
}
