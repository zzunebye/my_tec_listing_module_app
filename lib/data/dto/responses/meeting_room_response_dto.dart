import 'package:json_annotation/json_annotation.dart';
import 'package:my_tec_listing_module_app/data/dto/meeting_room_dto.dart';

part 'meeting_room_response_dto.g.dart';

@JsonSerializable()
class MeetingRoomResponseDto {
  final int pageCount;
  final int totalItemCount;
  final int pageNumber;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final bool isFirstPage;
  final bool isLastPage;
  final List<MeetingRoomDto> items;

  MeetingRoomResponseDto({
    required this.pageCount,
    required this.totalItemCount,
    required this.pageNumber,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.isFirstPage,
    required this.isLastPage,
    required this.items,
  });
  factory MeetingRoomResponseDto.fromJson(Map<String, dynamic> json) => _$MeetingRoomResponseDtoFromJson(json);

  Map<String,dynamic> toJson() => _$MeetingRoomResponseDtoToJson(this);
}