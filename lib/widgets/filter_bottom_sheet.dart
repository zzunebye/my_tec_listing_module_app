import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/widgets/titled_form_field.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key, required this.filterState, required this.onApply, required this.onReset});

  final void Function(FilterState) onApply;
  final void Function(FilterState) onReset;

  final FilterState filterState;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                // Reset filter logic here
              },
              child: Text('Reset'),
            ),
            Expanded(child: SizedBox.shrink()),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
        Divider(color: Theme.of(context).colorScheme.onSurface, thickness: 1.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              TitledFormField(
                title: 'Date',
                child: InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      // Handle the selected date here
                      // You might want to update your filter state
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Date', style: TextStyle(color: Colors.grey[600])),
                        Icon(Icons.calendar_today, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
              ),
              TitledFormField(
                title: 'Start Time',
                child: CustomTimePicker(label: 'Select Start Time'),
              ),
              TitledFormField(
                title: 'End Time',
                child: CustomTimePicker(label: 'Select End Time'),
              ),
              TitledFormField(
                title: 'Capacity',
                child: InkWell(
                  onTap: () async {
                    final String? selectedCapacity = await showCupertinoModalPopup<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(child: UnifiedFormFieldModalLayout(formField: UnifiedPicker()));
                      },
                    );
                    if (selectedCapacity != null) {
                      // Handle the selected capacity here
                      // You might want to update your filter state
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Capacity', style: TextStyle(color: Colors.grey[600])),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
              ),

              TitledFormField(
                title: 'Centres',
                child: DropdownButtonFormField<String>(
                  value: null,
                  onTap: () {},
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  hint: Text('Select Centres'),
                  items: <String>[
                    'Central',
                    'Tsim Sha Tsui', 
                    'Causeway Bay',
                    'Mong Kok',
                    'Kwun Tong'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      onTap: () {},
                      child: Row(
                        children: [
                          Checkbox(value: false, onChanged: (bool? value) {}),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle selection
                  },
                ),
              ),
              TitledFormField(
                title: 'Video Conference',
                child: Switch(
                  value: false, // You'll want to connect this to your filter state
                  onChanged: (bool value) {
                    // Handle switch state change here
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({super.key, this.label = 'Select Time'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showCupertinoModalPopup<TimeOfDay>(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: UnifiedFormFieldModalLayout(
                formField: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime.now().add(Duration(minutes: (5 - DateTime.now().minute % 5))),
                  minuteInterval: 5,
                  onDateTimeChanged: (DateTime newDateTime) {},
                ),
              ),
            );
          },
        );
        if (picked != null) {
          // Handle the selected time here
          // You might want to update your filter state
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[600])),
            Icon(Icons.access_time, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}

class UnifiedFormFieldModalLayout extends StatelessWidget {
  const UnifiedFormFieldModalLayout({super.key, required this.formField, this.height = 300.0});

  final Widget formField;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))),
            ),
            child: Center(child: Text('Select Capacity', style: Theme.of(context).textTheme.titleMedium)),
          ),
          // Picker
          Expanded(child: formField),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Save')),
        ],
      ),
    );
  }
}

class UnifiedPicker extends StatelessWidget {
  const UnifiedPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      diameterRatio: 1.0,
      itemExtent: 32.0,
      scrollController: FixedExtentScrollController(initialItem: 0),
      backgroundColor: Theme.of(context).colorScheme.surface,
      onSelectedItemChanged: (int index) {
        // Handle selection change if needed
      },
      children: List.generate(
        20,
        (index) => (index + 1).toString(),
      ).map((capacity) => Center(child: Text(capacity))).toList(),
    );
  }
}
