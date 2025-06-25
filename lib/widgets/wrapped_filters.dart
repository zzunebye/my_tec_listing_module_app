import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/widgets/filter_bottom_sheet.dart';

class WrappedFilters extends HookWidget {
  const WrappedFilters({
    super.key,
    this.searchMode = SearchMode.meetingRoom,
    required this.filterState,
    required this.centresInCurrentCity,
    required this.onResetFilter,
    required this.onApplyFilter,
  });

  final SearchMode searchMode;
  final MeetingRoomFilter filterState;
  final List<CentreDto> centresInCurrentCity;
  final void Function(MeetingRoomFilter) onResetFilter;
  final void Function(MeetingRoomFilter) onApplyFilter;

  void openFilterDialog(BuildContext context, MeetingRoomFilter filterState) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      useRootNavigator: true,
      context: context,
      builder: (context) => SafeArea(
        child: FilterBottomSheet(
          centres: centresInCurrentCity,
          filterState: filterState,
          searchMode: searchMode,
          onApply: (filterState) => onApplyFilter(filterState),
          onReset: (filterState) => onResetFilter(filterState),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 4.0,
        children: [
          FilterChip(
            elevation: 1,
            shadowColor: Colors.grey.shade200,
            visualDensity: VisualDensity.compact,
            avatar: Icon(Icons.filter_list, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
            key: Key('filter_chip_0'),
            label: Text('Filter', style: TextStyle(fontWeight: FontWeight.w600)),
            onSelected: (selected) => openFilterDialog(context, filterState),
          ),
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: Icon(Icons.today, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
            key: Key('filter_chip_1'),
            label: Text(
              DateTime.now().year == filterState.date.year &&
                      DateTime.now().month == filterState.date.month &&
                      DateTime.now().day == filterState.date.day
                  ? 'Today'
                  : filterState.date.toString().split(' ')[0],
            ),
            onSelected: (selected) => openFilterDialog(context, filterState),
          ),
          if (searchMode == SearchMode.meetingRoom)
            FilterChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(Icons.access_time, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
              key: Key('filter_chip_2'),
              label: Text(
                '${filterState.startTime.hour}:${filterState.startTime.minute.toString().padLeft(2, '0')} ${filterState.startTime.hour < 12 ? 'AM' : 'PM'} - ${filterState.endTime.hour}:${filterState.endTime.minute.toString().padLeft(2, '0')} ${filterState.endTime.hour < 12 ? 'AM' : 'PM'}',
              ),
              onSelected: (selected) => openFilterDialog(context, filterState),
            ),
          if (searchMode == SearchMode.meetingRoom || searchMode == SearchMode.dayOffice)
            FilterChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(Icons.chair, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
              key: Key('filter_chip_3'),
              label: Text('${filterState.capacity} Seats'),
              onSelected: (selected) => openFilterDialog(context, filterState),
            ),
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: Icon(Icons.location_on_outlined, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
            key: Key('filter_chip_4'),
            label: Text(() {
              final selectedItemCount = filterState.centres.length;
              final totalCountUnderCentres = centresInCurrentCity.length;
              return selectedItemCount == totalCountUnderCentres
                  ? 'All centres in the City'
                  : '$selectedItemCount centres selected';
            }()),
            onSelected: (selected) => openFilterDialog(context, filterState),
          ),
        ],
      ),
    );
  }
}
