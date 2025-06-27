import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';

class TECFormFieldHeader extends StatelessWidget {
  const TECFormFieldHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppBorderRadius.medium),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))),
      ),
      child: Center(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
    );
  }
}
