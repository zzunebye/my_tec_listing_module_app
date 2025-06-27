import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/tecc_form_field_header.dart';

class CustomPlatformTimePicker extends StatelessWidget {
  const CustomPlatformTimePicker({
    super.key,
    this.label = 'Select Time',
    required this.onSaved,
    required this.initialValue,
  });

  final String label;
  final void Function(DateTime) onSaved;
  final DateTime initialValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppBorderRadius.medium)),
      ),
      child: FormField(
        validator: (DateTime? value) {
          if (value == null) {
            return 'Time is required';
          }
          return null;
        },
        onSaved: (DateTime? value) {
          if (value != null) {
            onSaved(value);
          }
        },
        builder: (FormFieldState<DateTime> state) {
          return Column(
            children: [
              TECFormFieldHeader(label: label),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialValue,
                  minuteInterval: 15,
                  itemExtent: 32.0,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  onDateTimeChanged: (DateTime value) {
                    state.didChange(value);
                  },
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
