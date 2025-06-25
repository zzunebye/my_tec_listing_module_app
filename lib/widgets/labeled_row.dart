import 'package:flutter/material.dart';

class LabeledRow extends StatelessWidget {
  const LabeledRow({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(width: 8.0),
          Flexible(flex: 2, child: child),
        ],
      ),
    );
  }
}
