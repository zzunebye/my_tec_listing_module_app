// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_room_pricing_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingRoomPricingDto _$MeetingRoomPricingDtoFromJson(
  Map<String, dynamic> json,
) => MeetingRoomPricingDto(
  roomCode: json['roomCode'] as String,
  bestPricingStrategyName: json['bestPricingStrategyName'] as String,
  initialPrice: (json['initialPrice'] as num).toInt(),
  finalPrice: (json['finalPrice'] as num).toInt(),
  currencyCode: json['currencyCode'] as String,
  isPackageApplicable: json['isPackageApplicable'] as bool,
);

Map<String, dynamic> _$MeetingRoomPricingDtoToJson(
  MeetingRoomPricingDto instance,
) => <String, dynamic>{
  'roomCode': instance.roomCode,
  'bestPricingStrategyName': instance.bestPricingStrategyName,
  'initialPrice': instance.initialPrice,
  'finalPrice': instance.finalPrice,
  'currencyCode': instance.currencyCode,
  'isPackageApplicable': instance.isPackageApplicable,
};
