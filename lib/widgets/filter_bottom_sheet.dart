import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/widgets/labeled_row.dart';

class FilterBottomSheet extends HookWidget {
  const FilterBottomSheet({
    super.key,
    required this.filterState,
    required this.searchMode,
    required this.onApply,
    required this.onReset,
    required this.centres,
    this.selectableDateRangeOffset = 365,
  });

  // TODO: make filter visibility more easily configurable
  final SearchMode searchMode;
  final void Function(MeetingRoomFilter) onApply;
  final void Function(MeetingRoomFilter) onReset;

  final MeetingRoomFilter filterState;
  final int selectableDateRangeOffset;
  final List<CentreDto> centres;

  @override
  Widget build(BuildContext context) {
    final localFilterState = useState(filterState);
    final formKeyRef = useRef(GlobalKey<FormState>());
    final filterTargetStartTime = useMemoized(() {
      final date = localFilterState.value.date;
      final startTime = localFilterState.value.startTime;
      return DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );
    }, [localFilterState.value]);

    final filterTargetEndTime = useMemoized(() {
      final date = localFilterState.value.date;
      final endTime = localFilterState.value.endTime;
      return DateTime(
        date.year,
        date.month,
        date.day,
        endTime.hour,
        endTime.minute,
      );
    }, [localFilterState.value]);

    return Form(
      // onChanged: () {
      //   localFilterState.value = filterState;
      // },
      key: formKeyRef.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  onReset(filterState);
                  localFilterState.value = MeetingRoomFilter.defaultSettings();
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
                LabeledRow(
                  title: 'Date',
                  child: TextFormField(
                    controller: TextEditingController(text: localFilterState.value.date.toString().split(' ')[0]),
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: selectableDateRangeOffset)),
                      );
                      if (picked != null) {
                        localFilterState.value = localFilterState.value.copyWith(date: picked);
                      }
                    },
                  ),
                ),
                if (searchMode == SearchMode.meetingRoom)
                  LabeledRow(
                    title: 'Start Time',
                    child: TextFormField(
                      controller: TextEditingController(
                        text: convertDateTimeToTimeString(localFilterState.value.startTime),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) return 'Start Time is required';
                        if (filterTargetStartTime.isBefore(DateTime.now())) {
                          return 'Booking cannot be scheduled in the past';
                        }
                        if (filterTargetStartTime.isAfter(filterTargetEndTime)) {
                          return 'Start Time must be before End Time';
                        }
                        return null;
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Select Start Time',
                        suffixIcon: Icon(Icons.access_time, color: Colors.grey[600]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        errorMaxLines: 2,
                      ),
                      onTap: () async {
                        final DateTime? selectedTime = await showCupertinoModalPopup<DateTime>(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: CustomPlatformTimePicker(
                                initialValue: localFilterState.value.startTime,
                                onSaved: (DateTime value) {
                                  localFilterState.value = localFilterState.value.copyWith(startTime: value);
                                },
                              ),
                            );
                          },
                        );
                        if (selectedTime != null) {
                          localFilterState.value = localFilterState.value.copyWith(startTime: selectedTime);
                        }
                      },
                    ),
                  ),
                if (searchMode == SearchMode.meetingRoom)
                  LabeledRow(
                    title: 'End Time',
                    child: TextFormField(
                      controller: TextEditingController(
                        text: convertDateTimeToTimeString(localFilterState.value.endTime),
                      ),
                      readOnly: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) return 'End Time is required';
                        if (filterTargetStartTime.isAfter(filterTargetEndTime)) {
                          return 'End Time must be after Start Time';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Select End Time',
                        suffixIcon: Icon(Icons.access_time, color: Colors.grey[600]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onTap: () async {
                        final DateTime? selectedTime = await showCupertinoModalPopup<DateTime>(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: CustomPlatformTimePicker(
                                initialValue: localFilterState.value.endTime,
                                onSaved: (DateTime value) {
                                  localFilterState.value = localFilterState.value.copyWith(endTime: value);
                                },
                              ),
                            );
                          },
                        );
                        if (selectedTime != null) {
                          localFilterState.value = localFilterState.value.copyWith(endTime: selectedTime);
                        }
                      },
                    ),
                  ),
                if (searchMode == SearchMode.meetingRoom || searchMode == SearchMode.dayOffice)
                  LabeledRow(
                    title: 'Capacity',
                    child: TextFormField(
                      // initialValue: localFilterState.value.capacity.toString(),
                      controller: TextEditingController(text: (localFilterState.value.capacity).toString()),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Select Capacity',
                        suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onTap: () async {
                        final int? selectedCapacity = await showCupertinoModalPopup<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: CustomPlatformPicker(
                                initialValue: localFilterState.value.capacity,
                                onSaved: (int value) {
                                  localFilterState.value = localFilterState.value.copyWith(capacity: value);
                                },
                              ),
                            );
                          },
                        );
                        if (selectedCapacity != null) {
                          localFilterState.value = localFilterState.value.copyWith(capacity: selectedCapacity);
                        }
                      },
                    ),
                  ),

                LabeledRow(
                  title: 'Centres',
                  child: FormField<List<String>>(
                    initialValue: localFilterState.value.centres,
                    onSaved: (value) {
                      localFilterState.value = localFilterState.value.copyWith(centres: value ?? []);
                    },
                    builder: (FormFieldState<List<String>> state) {
                      return InkWell(
                        onTap: () async {
                          List<String> tempSelectedCentres = List<String>.from(state.value ?? []);
                          final List<String>? result = await showDialog<List<String>>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Select Centres'),
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: centres.map((CentreDto centre) {
                                          return CheckboxListTile(
                                            title: Text(centre.localizedName?['en'] ?? ''),
                                            value: tempSelectedCentres.contains(centre.localizedName?['en'] ?? ''),
                                            onChanged: (bool? checked) {
                                              setState(() {
                                                if (checked ?? false) {
                                                  tempSelectedCentres.add(centre.localizedName?['en'] ?? '');
                                                } else {
                                                  tempSelectedCentres.remove(centre.localizedName?['en'] ?? '');
                                                }
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop(tempSelectedCentres);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          if (result != null) {
                            state.didChange(result);
                            localFilterState.value = localFilterState.value.copyWith(centres: result);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          child: Text(
                            () {
                              final selectedItemCount = localFilterState.value.centres.length;
                              final totalCountUnderCentres = centres.length;
                              if (selectedItemCount == 0) {
                                return 'Select Centres';
                              } else if (selectedItemCount == totalCountUnderCentres) {
                                return 'All centres in the City';
                              } else {
                                return '$selectedItemCount centres selected';
                              }
                            }(),
                            // state.value?.isEmpty ?? true ? 'Select Centres' : state.value!.join(', '),
                            style: state.value?.isEmpty ?? true
                                ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])
                                : Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (searchMode == SearchMode.meetingRoom)
                  LabeledRow(
                    title: 'Video Conference',
                    child: FormField<bool>(
                      onSaved: (bool? value) {
                        localFilterState.value = localFilterState.value.copyWith(canVideoConference: value ?? false);
                      },
                      builder: (FormFieldState<bool> state) {
                        return Switch(
                          value: state.value ?? false,
                          onChanged: (bool value) {
                            // localFilterState.value = localFilterState.value.copyWith(canVideoConference: value);
                            state.didChange(value);
                          },
                        );
                      },
                      initialValue: localFilterState.value.canVideoConference,
                    ),
                  ),
                if (searchMode == SearchMode.dayOffice)
                  LabeledRow(
                    title: 'Window',
                    child: FormField<bool>(
                      onSaved: (bool? value) {
                        localFilterState.value = localFilterState.value.copyWith(requiredWindow: value ?? false);
                      },
                      builder: (FormFieldState<bool> state) {
                        return Switch(
                          value: state.value ?? false,
                          onChanged: (bool value) {
                            // localFilterState.value = localFilterState.value.copyWith(canVideoConference: value);
                            state.didChange(value);
                          },
                        );
                      },
                      initialValue: localFilterState.value.requiredWindow,
                    ),
                  ),

                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48.0),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    final form = formKeyRef.value.currentState;
                    if (form == null) return;

                    final isValid = form.validate();
                    if (!isValid) return;

                    form.save(); // 여기서 각 FormField의 onSaved가 실행되어 _draft에 값 저장됨

                    // 이 시점에서 단 1회만 전역 상태 업데이트
                    localFilterState.value = localFilterState.value.copyWith(
                      date: localFilterState.value.date,
                      startTime: localFilterState.value.startTime,
                      endTime: localFilterState.value.endTime,
                      capacity: localFilterState.value.capacity,
                      centres: localFilterState.value.centres,
                      canVideoConference: localFilterState.value.canVideoConference,
                    );

                    onApply(localFilterState.value);

                    Navigator.of(context).pop();
                  },
                  child: Text('Apply'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String convertDateTimeToTimeString(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'AM' : 'PM'}';
  }
}

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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: FormField(
        onSaved: (DateTime? value) {
          if (value != null) {
            onSaved(value);
          }
        },
        builder: (FormFieldState<DateTime> state) {
          return Column(
            children: [
              TECFormFieldHeader(),
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

class CustomPlatformPicker extends StatelessWidget {
  const CustomPlatformPicker({super.key, required this.onSaved, this.initialValue = 1});

  final void Function(int) onSaved;
  final int initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
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
              TECFormFieldHeader(),
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

class TECFormFieldHeader extends StatelessWidget {
  const TECFormFieldHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))),
      ),
      child: Center(child: Text('Select Capacity', style: Theme.of(context).textTheme.titleMedium)),
    );
  }
}
