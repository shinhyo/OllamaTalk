import 'package:flutter/material.dart';

// https://github.com/singerdmx/flutter-quill/issues/1697#issuecomment-2311548151
class OverlayBoundary extends StatefulWidget {
  const OverlayBoundary({super.key, required this.child});

  final Widget child;

  @override
  State<OverlayBoundary> createState() => _OverlayBoundaryState();
}

class _OverlayBoundaryState extends State<OverlayBoundary> {
  late final OverlayEntry _overlayEntry =
      OverlayEntry(builder: (context) => widget.child);

  @override
  void didUpdateWidget(covariant OverlayBoundary oldWidget) {
    super.didUpdateWidget(oldWidget);
    _overlayEntry.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [_overlayEntry],
    );
  }
}
