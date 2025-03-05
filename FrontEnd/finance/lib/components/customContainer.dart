// custom_container.dart
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  const CustomContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.only(top: 40, bottom: 20),
    this.color = const Color(0xFFD4CFE0),
    this.borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30),
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}