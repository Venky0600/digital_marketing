import 'package:flutter/material.dart';
import 'clay_container.dart';

class ClayButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double borderRadius;
  final double depth;

  const ClayButton({
    super.key,
    required this.child,
    required this.onTap,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.color,
    this.borderRadius = 24.0,
    this.depth = 4.0,
  });

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ClayContainer(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          color: widget.color,
          borderRadius: widget.borderRadius,
          depth: widget.depth,
          isPushed: _isPressed,
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
