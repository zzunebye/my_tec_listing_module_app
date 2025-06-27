import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/presentation/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/utils/date.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/custom_platform_picker.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/custom_platform_time_picker.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/labeled_row.dart';

class FilterBottomSheet extends HookWidget {
  const FilterBottomSheet({
    super.key,
    required this.filterState,
    required this.searchMode,
    required this.onApply,
    required this.onReset,
    required this.centres,
    required this.currentCity,
    this.selectableDateRangeOffset = 365,
    this.tappedFormField,
  });

  // TODO: make filter visibility more easily configurable
  final SearchMode searchMode;
  final void Function(MeetingRoomFilter) onApply;
  final void Function(MeetingRoomFilter) onReset;

  final MeetingRoomFilter filterState;
  final int selectableDateRangeOffset;
  final List<CentreDto> centres;
  final CityState currentCity;
  final String? tappedFormField;

  @override
  Widget build(BuildContext context) {
    final localFilterState = useState(filterState);
    final formKeyRef = useRef(GlobalKey<FormState>());
    final filterTargetStartTime = useMemoized(() {
      final date = localFilterState.value.date;
      final startTime = localFilterState.value.startTime;
      return DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute);
    }, [localFilterState.value]);

    final filterTargetEndTime = useMemoized(() {
      final date = localFilterState.value.date;
      final endTime = localFilterState.value.endTime;
      return DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
    }, [localFilterState.value]);

    final dateKey = GlobalKey();
    final startTimeKey = GlobalKey();
    final endTimeKey = GlobalKey();
    final capacityKey = GlobalKey();
    final centresKey = GlobalKey();

    useEffect(() {
      // Schedule focus request after first frame is rendered
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 100), () {
          if (tappedFormField != null) {
            switch (tappedFormField) {
              case 'date':
                final dateField = dateKey.currentWidget as GestureDetector?;
                dateField?.onTap?.call();
                break;
              case 'start_time':
                final startTimeField = startTimeKey.currentWidget as GestureDetector?;
                startTimeField?.onTap?.call();
                break;
              case 'end_time':
                final endTimeField = endTimeKey.currentWidget as GestureDetector?;
                endTimeField?.onTap?.call();
                break;
              case 'capacity':
                final capacityField = capacityKey.currentWidget as GestureDetector?;
                capacityField?.onTap?.call();
                break;
              case 'centres':
                final centresField = centresKey.currentWidget as GestureDetector?;
                centresField?.onTap?.call();
                break;
            }
          }
        });
      });
      return null;
    }, []);

    return Form(
      key: formKeyRef.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xSmall, right: AppSpacing.xSmall, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    onReset(filterState);
                    localFilterState.value = MeetingRoomFilter.defaultSettings();
                  },
                  child: Text(
                    'Reset',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.subtitle),
                  ),
                ),
                Expanded(child: SizedBox.shrink()),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_outlined, color: AppColors.subtitle),
                ),
              ],
            ),
          ),
          Divider(color: Theme.of(context).colorScheme.outline, thickness: 1.0, height: 0.0),
          SizedBox(height: AppSpacing.xSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xSmall),
            child: Column(
              children: [
                LabeledRow(
                  title: 'Date',
                  child: GestureDetector(
                    key: dateKey,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: localFilterState.value.date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: selectableDateRangeOffset)),
                      );
                      if (picked != null) {
                        localFilterState.value = localFilterState.value.copyWith(date: picked);
                      }
                    },
                    child: TextFormField(
                      enabled: false,
                      style: Theme.of(context).textTheme.labelLarge,
                      controller: TextEditingController(text: formatDateTimeToDateString(localFilterState.value.date)),
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppBorderRadius.normal)),
                      ),
                    ),
                  ),
                ),
                if (searchMode == SearchMode.meetingRoom)
                  LabeledRow(
                    title: 'Start Time',
                    child: GestureDetector(
                      key: startTimeKey,
                      onTap: () async {
                        final DateTime? selectedTime = await showCupertinoModalPopup<DateTime>(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: CustomPlatformTimePicker(
                                label: 'Select Start Time',
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
                      child: TextFormField(
                        enabled: false,
                        style: Theme.of(context).textTheme.labelLarge,
                        controller: TextEditingController(
                          text: formatDateTimeToTimeString(localFilterState.value.startTime),
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
                          suffixIcon: Icon(Icons.access_time_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppBorderRadius.normal)),
                          errorMaxLines: 2,
                        ),
                      ),
                    ),
                  ),
                if (searchMode == SearchMode.meetingRoom)
                  LabeledRow(
                    title: 'End Time',
                    child: GestureDetector(
                      key: endTimeKey,
                      onTap: () async {
                        final DateTime? selectedTime = await showCupertinoModalPopup<DateTime>(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: CustomPlatformTimePicker(
                                label: 'Select End Time',
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
                      child: TextFormField(
                        enabled: false,
                        style: Theme.of(context).textTheme.labelLarge,
                        controller: TextEditingController(
                          text: formatDateTimeToTimeString(localFilterState.value.endTime),
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
                          suffixIcon: Icon(Icons.access_time_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppBorderRadius.normal)),
                        ),
                      ),
                    ),
                  ),
                if (searchMode == SearchMode.meetingRoom || searchMode == SearchMode.dayOffice)
                  LabeledRow(
                    title: 'Capacity',
                    child: GestureDetector(
                      key: capacityKey,
                      onTap: () async {
                        final int? selectedCapacity = await showCupertinoModalPopup<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: CustomPlatformPicker(
                                label: 'Select Capacity',
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
                      child: TextFormField(
                        enabled: false,
                        style: Theme.of(context).textTheme.labelLarge,
                        controller: TextEditingController(text: (localFilterState.value.capacity).toString()),
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Select Capacity',
                          suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppBorderRadius.normal)),
                        ),
                        // onTap: () async {
                        //   final int? selectedCapacity = await showCupertinoModalPopup<int>(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return SafeArea(
                        //         child: CustomPlatformPicker(
                        //           label: 'Select Capacity',
                        //           initialValue: localFilterState.value.capacity,
                        //           onSaved: (int value) {
                        //             localFilterState.value = localFilterState.value.copyWith(capacity: value);
                        //           },
                        //         ),
                        //       );
                        //     },
                        //   );
                        //   if (selectedCapacity != null) {
                        //     localFilterState.value = localFilterState.value.copyWith(capacity: selectedCapacity);
                        //   }
                        // },
                      ),
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
                      return GestureDetector(
                        key: centresKey,
                        onTap: () async {
                          List<String> tempSelectedCentres = List<String>.from(state.value ?? []);
                          final List<String>? result = await showDialog<List<String>>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                alignment: Alignment.bottomCenter,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xSmall,
                                  vertical: AppSpacing.xSmall,
                                ),
                                title: Text('Select Centres'),
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CheckboxListTile(
                                            title: Text(
                                              'All Centres in ${currentCity.cityName}',
                                              style: TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            value: tempSelectedCentres.length == centres.length,
                                            visualDensity: VisualDensity.compact,
                                            onChanged: (bool? checked) {
                                              setState(() {
                                                if (checked ?? false) {
                                                  tempSelectedCentres = centres
                                                      .map((centre) => centre.localizedName?['en'] ?? '')
                                                      .toList();
                                                } else {
                                                  tempSelectedCentres.clear();
                                                }
                                              });
                                            },
                                          ),
                                          Divider(height: 1),
                                          ...centres.map((CentreDto centre) {
                                            return CheckboxListTile(
                                              title: Text(centre.localizedName?['en'] ?? ''),
                                              value: tempSelectedCentres.contains(centre.localizedName?['en'] ?? ''),
                                              visualDensity: VisualDensity.compact,
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
                                        ],
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
                        child: TextFormField(
                          enabled: false,
                          style: Theme.of(context).textTheme.labelLarge,
                          controller: TextEditingController(
                            text: () {
                              final selectedItemCount = state.value?.length ?? 0;
                              final totalCountUnderCentres = centres.length;
                              if (selectedItemCount == 0) {
                                return 'Select Centres';
                              } else if (selectedItemCount == totalCountUnderCentres) {
                                return 'All centres in the City';
                              } else {
                                return '$selectedItemCount centres selected';
                              }
                            }(),
                          ),
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_drop_down_outlined, color: AppColors.disabled),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppBorderRadius.normal)),
                          ),
                          // child: Text(
                          //   () {
                          //     final selectedItemCount = localFilterState.value.centres.length;
                          //     final totalCountUnderCentres = centres.length;
                          //     if (selectedItemCount == 0) {
                          //       return 'Select Centres';
                          //     } else if (selectedItemCount == totalCountUnderCentres) {
                          //       return 'All centres in the City';
                          //     } else {
                          //       return '$selectedItemCount centres selected';
                          //     }
                          //   }(),
                          //   // state.value?.isEmpty ?? true ? 'Select Centres' : state.value!.join(', '),
                          //   style: state.value?.isEmpty ?? true
                          //       ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])
                          //       : Theme.of(context).textTheme.bodyMedium,
                          // ),
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
                            state.didChange(value);
                          },
                        );
                      },
                      initialValue: localFilterState.value.requiredWindow,
                    ),
                  ),

                SizedBox(height: AppSpacing.medium),
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
                SizedBox(height: MediaQuery.of(context).systemGestureInsets.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
