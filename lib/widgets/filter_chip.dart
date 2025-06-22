import 'package:flutter/material.dart';

class FilterChip extends StatelessWidget {
  const FilterChip({super.key, required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        avatar: Icon(icon, size: 18.0, color: Theme.of(context).colorScheme.surface),
        label: Text(label, style: Theme.of(context).textTheme.labelMedium),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        labelPadding: const EdgeInsets.only(left: 2.0, right: 4.0),
      ),
    );
  }
}
