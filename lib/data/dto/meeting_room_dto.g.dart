// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_room_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingRoomDto _$MeetingRoomDtoFromJson(Map<String, dynamic> json) =>
    MeetingRoomDto(
      centreCode: json['centreCode'] as String,
      roomCode: json['roomCode'] as String,
      roomName: json['roomName'] as String,
      floor: json['floor'] as String,
      capacity: (json['capacity'] as num).toInt(),
      hasVideoConference: json['hasVideoConference'] as bool,
      amenities: (json['amenities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      photoUrls: (json['photoUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isBookable: json['isBookable'] as bool,
      isFromNewObs: json['isFromNewObs'] as bool,
      isClosed: json['isClosed'] as bool,
      isInternal: json['isInternal'] as bool,
    );

Map<String, dynamic> _$MeetingRoomDtoToJson(MeetingRoomDto instance) =>
    <String, dynamic>{
      'centreCode': instance.centreCode,
      'roomCode': instance.roomCode,
      'roomName': instance.roomName,
      'floor': instance.floor,
      'capacity': instance.capacity,
      'hasVideoConference': instance.hasVideoConference,
      'amenities': instance.amenities,
      'photoUrls': instance.photoUrls,
      'isBookable': instance.isBookable,
      'isFromNewObs': instance.isFromNewObs,
      'isClosed': instance.isClosed,
      'isInternal': instance.isInternal,
    };
