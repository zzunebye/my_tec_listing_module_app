import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
import 'package:my_tec_listing_module_app/widgets/tecc_form_field_header.dart';

/// When save button is clicked, state.save() is called, which will trigger onSaved callback.
class CustomPlatformPicker extends StatelessWidget {
  const CustomPlatformPicker({super.key, required this.onSaved, this.initialValue = 1, required this.label});

  final String label;
  final void Function(int) onSaved;
  final int initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppBorderRadius.medium)),
      ),
      child: FormField<int>(
        onSaved: (int? value) {
          if (value != null) {
            onSaved(value);
          }
        },
        builder: (FormFieldState<int> state) {
          return Column(
            children: [
              TECFormFieldHeader(label: label),
              Expanded(
                child: CupertinoPicker(
                  diameterRatio: 1.0,
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(initialItem: initialValue - 1),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  onSelectedItemChanged: (int index) {
                    state.didChange(index + 1);
                  },
                  children: List.generate(
                    20,
                    (index) => (index + 1).toString(),
                  ).map((capacity) => Center(child: Text(capacity))).toList(),
                ),
              ),
              TextButton(
                onPressed: () {
                  state.save();
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
