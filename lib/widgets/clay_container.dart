import 'package:flutter/material.dart';
import '../theme/clay_theme.dart';

class ClayContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double borderRadius;
  final bool isPushed;
  final double depth;

  const ClayContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius = 24.0,
    this.isPushed = false,
    this.depth = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? ClayTheme.background;
    
    // We calculate a slightly lighter color for the top-left edge
    // and a darker color for the bottom-right shadow.
    // If it's pushed in, we reverse the shadows.

    final shadowLight = ClayTheme.shadowLight;
    final shadowDark = ClayTheme.shadowDark;

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPushed
            ? null // For inner shadows we might need a custom painter or just flat
            : [
                BoxShadow(
                  color: shadowDark,
                  offset: Offset(depth, depth),
                  blurRadius: depth * 2,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: shadowLight,
                  offset: Offset(-depth, -depth),
                  blurRadius: depth * 2,
                  spreadRadius: 1,
                ),
              ],
        // To simulate inner shadow for `isPushed`, we could use a gradient, 
        // but for a simple claymorphism look, we can just alter the background color slightly
        // or rely on outer shadows. Standard flutter doesn't have an easy inner shadow.
      ),
      child: child,
    );
  }
}
