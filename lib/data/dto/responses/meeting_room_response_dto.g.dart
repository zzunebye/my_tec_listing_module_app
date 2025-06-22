// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_room_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingRoomResponseDto _$MeetingRoomResponseDtoFromJson(
  Map<String, dynamic> json,
) => MeetingRoomResponseDto(
  pageCount: (json['pageCount'] as num).toInt(),
  totalItemCount: (json['totalItemCount'] as num).toInt(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
  isFirstPage: json['isFirstPage'] as bool,
  isLastPage: json['isLastPage'] as bool,
  items: (json['items'] as List<dynamic>)
      .map((e) => MeetingRoomDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MeetingRoomResponseDtoToJson(
  MeetingRoomResponseDto instance,
) => <String, dynamic>{
  'pageCount': instance.pageCount,
  'totalItemCount': instance.totalItemCount,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
  'isFirstPage': instance.isFirstPage,
  'isLastPage': instance.isLastPage,
  'items': instance.items,
};
