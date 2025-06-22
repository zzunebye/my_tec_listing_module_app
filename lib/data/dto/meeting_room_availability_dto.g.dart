// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_room_availability_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingRoomAvailabilityDto _$MeetingRoomAvailabilityDtoFromJson(
  Map<String, dynamic> json,
) => MeetingRoomAvailabilityDto(
  roomCode: json['roomCode'] as String,
  isAvailable: json['isAvailable'] as bool,
  isWithinOfficeHour: json['isWithinOfficeHour'] as bool,
  isPast: json['isPast'] as bool,
  nextAvailabilities: json['nextAvailabilities'] as List<dynamic>,
);

Map<String, dynamic> _$MeetingRoomAvailabilityDtoToJson(
  MeetingRoomAvailabilityDto instance,
) => <String, dynamic>{
  'roomCode': instance.roomCode,
  'isAvailable': instance.isAvailable,
  'isWithinOfficeHour': instance.isWithinOfficeHour,
  'isPast': instance.isPast,
  'nextAvailabilities': instance.nextAvailabilities,
};
