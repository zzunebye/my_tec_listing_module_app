import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
import 'package:my_tec_listing_module_app/domain/entities/grouped_meeting_room_entity.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/room_card.dart';

class MeetingRoomListView extends StatelessWidget {
  const MeetingRoomListView({required this.onRefresh, required this.groupedMeetingRoomEntityList, super.key});

  final RefreshCallback onRefresh;
  final List<GroupedMeetingRoomEntity> groupedMeetingRoomEntityList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              // controller: scrollController,
              itemCount: groupedMeetingRoomEntityList.fold<int>(
                0,
                (count, group) => count + group.meetingRooms.length + 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                int currentIndex = 0;
                for (final group in groupedMeetingRoomEntityList) {
                  if (group.meetingRooms.isEmpty) continue;
                  // Check if this index is the group header
                  if (index == currentIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      child: Text(
                        group.centreName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  currentIndex++;

                  // Check if this index is within this group's meeting rooms
                  if (index >= currentIndex && index < currentIndex + group.meetingRooms.length) {
                    final roomIndex = index - currentIndex;
                    return MeetingRoomCard(meetingRoom: group.meetingRooms[roomIndex]);
                  }
                  currentIndex += group.meetingRooms.length;
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}
