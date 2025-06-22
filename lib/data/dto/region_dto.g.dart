// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionDto _$RegionDtoFromJson(Map<String, dynamic> json) => RegionDto(
  id: json['id'] as String,
  name: NameTranslationDto.fromJson(json['name'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegionDtoToJson(RegionDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
