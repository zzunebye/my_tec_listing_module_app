import 'package:flutter/material.dart';

class TitledFormField extends StatelessWidget {
  const TitledFormField({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(width: 16.0),
          Flexible(flex: 2, child: child),
        ],
      ),
    );
  }
}
