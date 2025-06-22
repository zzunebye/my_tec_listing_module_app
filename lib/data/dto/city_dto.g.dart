// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityDto _$CityDtoFromJson(Map<String, dynamic> json) => CityDto(
  cityId: (json['cityId'] as num).toInt(),
  countryId: (json['countryId'] as num).toInt(),
  code: json['code'] as String,
  name: json['name'] as String,
  timeZone: json['timeZone'] as Map<String, dynamic>,
  isActive: json['isActive'] as bool,
  accountEmail: json['accountEmail'] as String,
  currencyIsoCode: json['currencyIsoCode'] as String,
  generalEmail: json['generalEmail'] as String,
  generalPhone: json['generalPhone'] as String?,
  meEmail: json['meEmail'] as String,
  nameTranslation: NameTranslationDto.fromJson(
    json['nameTranslation'] as Map<String, dynamic>,
  ),
  paymentGateway: json['paymentGateway'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
  sequence: (json['sequence'] as num?)?.toInt(),
  voCwEmail: json['voCwEmail'] as String,
  bdGroupEmail: json['bdGroupEmail'] as String,
  region: RegionDto.fromJson(json['region'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CityDtoToJson(CityDto instance) => <String, dynamic>{
  'cityId': instance.cityId,
  'countryId': instance.countryId,
  'code': instance.code,
  'name': instance.name,
  'timeZone': instance.timeZone,
  'isActive': instance.isActive,
  'accountEmail': instance.accountEmail,
  'currencyIsoCode': instance.currencyIsoCode,
  'generalEmail': instance.generalEmail,
  'generalPhone': instance.generalPhone,
  'meEmail': instance.meEmail,
  'nameTranslation': instance.nameTranslation,
  'paymentGateway': instance.paymentGateway,
  'paymentMethod': instance.paymentMethod,
  'sequence': instance.sequence,
  'voCwEmail': instance.voCwEmail,
  'bdGroupEmail': instance.bdGroupEmail,
  'region': instance.region,
};
