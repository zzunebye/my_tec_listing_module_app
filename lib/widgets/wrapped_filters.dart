import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/widgets/filter_bottom_sheet.dart';

class WrappedFilters extends HookWidget {
  const WrappedFilters({super.key});

  void openFilterDialog(BuildContext context, MeetingRoomFilter filterState) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      useRootNavigator: true,
      context: context,
      builder: (context) => SafeArea(
        child: FilterBottomSheet(
          filterState: filterState,
          onApply: (filterState) {},
          onReset: (filterState) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterState = useState(
      MeetingRoomFilter(
        capacity: 0,
        date: DateTime.now(),
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        canVideoConference: false,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 4.0,
        // runSpacing: 8.0,
        children: [
          FilterChip(
            avatar: Icon(Icons.filter_list, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
            key: Key('filter_chip_0'),
            label: Text('Filter'),
            onSelected: (selected) => openFilterDialog(context, filterState.value),
          ),
          FilterChip(
            avatar: Icon(Icons.today, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
            key: Key('filter_chip_1'),
            label: Text('Today'),
            onSelected: (selected) => openFilterDialog(context, filterState.value),
          ),
          FilterChip(
            avatar: Icon(Icons.access_time, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
            key: Key('filter_chip_2'),
            label: Text('06:15 PM - 06:45 PM'),
            onSelected: (selected) => openFilterDialog(context, filterState.value),
          ),
          FilterChip(
            avatar: Icon(Icons.chair, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
            key: Key('filter_chip_3'),
            label: Text('4 Seats'),
            onSelected: (selected) => openFilterDialog(context, filterState.value),
          ),
          FilterChip(
            avatar: Icon(Icons.location_on_outlined, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
            key: Key('filter_chip_4'),
            label: Text('All centres in the City'),
            onSelected: (selected) => openFilterDialog(context, filterState.value),
          ),
        ],
      ),
    );
  }
}
