import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes/theme_ext.dart';

class ChipMenuAnchor extends StatefulWidget {
  final bool isMini;
  final SvgPicture icon;
  final List<String> list;
  final int index;
  final String? tooltip;
  final Function(String?)? onSelected;

  const ChipMenuAnchor({
    super.key,
    this.isMini = false,
    required this.icon,
    required this.list,
    required this.index,
    required this.onSelected,
    this.tooltip,
  });

  @override
  State<ChipMenuAnchor> createState() => _ChipMenuAnchorState();
}

class _ChipMenuAnchorState extends State<ChipMenuAnchor> {
  late MenuController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = MenuController();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8.0);

    if (widget.list.isEmpty) {
      return _buildChild(context, borderRadius, null);
    }

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(0, 4),
      menuChildren: widget.list
          .map(
            (item) => MenuItemButton(
              onPressed: () {
                widget.onSelected?.call(item);
                _menuController.close();
              },
              child: Text(item),
            ),
          )
          .toList(),
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: _buildChild(context, borderRadius, widget.list[widget.index]),
        );
      },
    );
  }

  Widget _buildChild(
    BuildContext context,
    BorderRadius borderRadius,
    String? title,
  ) {
    return widget.isMini
        ? Material(
            color: Colors.transparent,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: widget.icon,
            ),
          )
        : Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: context.color.surface,
              borderRadius: borderRadius,
              border: Border.all(
                color: context.color.outline.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.icon,
                const SizedBox(width: 8),
                if (title != null &&
                    widget.list.isNotEmpty &&
                    widget.index >= 0 &&
                    widget.index < widget.list.length)
                  Text(title),
              ],
            ),
          );
  }
}
