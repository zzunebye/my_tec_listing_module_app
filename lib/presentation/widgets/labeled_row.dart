import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';

class LabeledRow extends StatelessWidget {
  const LabeledRow({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.xSmall, horizontal: AppSpacing.medium),
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
          Flexible(flex: 1, child: Text(title, style: Theme.of(context).textTheme.labelLarge)),
          const SizedBox(width: AppSpacing.xSmall),
          Flexible(flex: 2, child: child),
        ],
      ),
    );
  }
}
