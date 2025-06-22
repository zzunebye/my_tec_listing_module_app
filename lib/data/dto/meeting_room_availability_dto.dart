import 'package:json_annotation/json_annotation.dart';

part 'meeting_room_availability_dto.g.dart';

@JsonSerializable()
class MeetingRoomAvailabilityDto {
  final String roomCode;
  final bool isAvailable;
  final bool isWithinOfficeHour;
  final bool isPast;
  final List<dynamic> nextAvailabilities;

  MeetingRoomAvailabilityDto({
    required this.roomCode,
    required this.isAvailable,
    required this.isWithinOfficeHour,
    required this.isPast,
    required this.nextAvailabilities,
  });

  factory MeetingRoomAvailabilityDto.fromJson(Map<String, dynamic> json) => _$MeetingRoomAvailabilityDtoFromJson(json);

  Map<String,dynamic> toJson() => _$MeetingRoomAvailabilityDtoToJson(this);
}