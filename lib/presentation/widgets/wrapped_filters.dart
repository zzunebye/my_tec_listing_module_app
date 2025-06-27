import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/presentation/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/utils/date.dart';

class WrappedFilters extends HookWidget {
  const WrappedFilters({
    super.key,
    this.searchMode = SearchMode.meetingRoom,
    required this.filterState,
    required this.centresInCurrentCity,
    required this.onFilterTapped,
  });

  final SearchMode searchMode;
  final MeetingRoomFilter filterState;
  final List<CentreDto> centresInCurrentCity;
  final void Function(String?) onFilterTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 4.0,
        children: [
          FilterChip(
            shadowColor: Theme.of(context).colorScheme.outline,
            visualDensity: VisualDensity.compact,
            avatar: Icon(Icons.filter_list_outlined, color: AppColors.primary),
            key: Key('filter_chip_0'),
            label: Text('Filter', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
            onSelected: (selected) => onFilterTapped(null),
          ),
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: Icon(Icons.calendar_today_outlined, color: AppColors.subtitle),
            key: Key('filter_chip_1'),
            label: Text(
              formatDateTimeToDateString(filterState.date),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.subtitle),
            ),
            onSelected: (selected) => onFilterTapped('date'),
          ),
          if (searchMode == SearchMode.meetingRoom)
            FilterChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(Icons.access_time_outlined, color: AppColors.subtitle),
              key: Key('filter_chip_2'),
              label: Text(
                '${formatDateTimeToTimeString(filterState.startTime)} - ${formatDateTimeToTimeString(filterState.endTime)}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.subtitle),
              ),
              onSelected: (selected) => onFilterTapped('start_time'),
            ),
          if (searchMode == SearchMode.meetingRoom || searchMode == SearchMode.dayOffice)
            FilterChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(Icons.people_outline_outlined, color: AppColors.subtitle),
              key: Key('filter_chip_3'),
              label: Text(
                '${filterState.capacity} Seats',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.subtitle),
              ),
              onSelected: (selected) => onFilterTapped('capacity'),
            ),
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: Icon(Icons.location_city_outlined, color: AppColors.subtitle),
            key: Key('filter_chip_4'),
            label: Text(() {
              final selectedItemCount = filterState.centres.length;
              final totalCountUnderCentres = centresInCurrentCity.length;
              return selectedItemCount == totalCountUnderCentres
                  ? 'All centres in the City'
                  : '$selectedItemCount centres selected';
            }(), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.subtitle)),
            onSelected: (selected) => onFilterTapped('centres'),
          ),
        ],
      ),
    );
  }
}
