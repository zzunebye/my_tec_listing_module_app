import 'package:json_annotation/json_annotation.dart';

part 'meeting_room_pricing_dto.g.dart';

@JsonSerializable()
class MeetingRoomPricingDto {
  final String roomCode;
  final String bestPricingStrategyName;
  final int initialPrice;
  final int finalPrice;
  final String currencyCode;
  final bool isPackageApplicable;

  MeetingRoomPricingDto({

    required this.roomCode,
    required this.bestPricingStrategyName,
    required this.initialPrice,
    required this.finalPrice,
    required this.currencyCode,
    required this.isPackageApplicable,
  });

  factory MeetingRoomPricingDto.fromJson(Map<String, dynamic> json) => _$MeetingRoomPricingDtoFromJson(json);

  Map<String,dynamic> toJson() => _$MeetingRoomPricingDtoToJson(this);
}