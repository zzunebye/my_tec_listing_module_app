import 'package:my_tec_listing_module_app/domain/entities/meeting_room_entity.dart';

class GroupedMeetingRoomEntity {
  final String centreName;
  final String centreCode;
  final List<MeetingRoomEntity> meetingRooms;
  final double? distance;

  GroupedMeetingRoomEntity({
    required this.centreName,
    required this.centreCode,
    required this.meetingRooms,
    this.distance,
  });
}
