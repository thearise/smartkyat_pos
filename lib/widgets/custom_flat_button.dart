import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final Color? foregroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;

  const CustomFlatButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color,
    this.foregroundColor,
    this.elevation,
    this.padding,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: foregroundColor,
        elevation: elevation,
        padding: padding,
        shape: shape,
      ),
      child: child,
    );
  }
}
