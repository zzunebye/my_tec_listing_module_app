// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'centre_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CentreDto _$CentreDtoFromJson(Map<String, dynamic> json) => CentreDto(
  id: json['id'] as String,
  amenities: Map<String, bool>.from(json['amenities'] as Map),
  country: json['country'] as String,
  centreCodesForVoCwCheckout:
      (json['centreCodesForVoCwCheckout'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  centreHighlights: Map<String, String?>.from(json['centreHighlights'] as Map),
  cityId: json['cityId'] as String,
  citySlug: json['citySlug'] as String,
  cityCode: json['cityCode'] as String,
  displayEmail: json['displayEmail'] as String,
  displayPhone: json['displayPhone'] as String,
  centreSchedule: (json['centreSchedule'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String?)),
    ),
  ),
  grossSizeSqFt: (json['grossSizeSqFt'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool,
  centreTrafficInfo: Map<String, String?>.from(
    json['centreTrafficInfo'] as Map,
  ),
  displayAddress: Map<String, String?>.from(json['displayAddress'] as Map),
  addressLevel: json['addressLevel'] as String,
  localizedName: Map<String, String?>.from(json['localizedName'] as Map),
  mapboxCoordinates: (json['mapboxCoordinates'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  slug: json['slug'] as String,
  netSizeSqFt: (json['netSizeSqFt'] as num).toInt(),
  noOfFloors: (json['noOfFloors'] as num).toInt(),
  noOfMeetingRoom: (json['noOfMeetingRoom'] as num).toInt(),
  sequence: Map<String, String?>.from(json['sequence'] as Map),
  status: json['status'] as String,
  tecTacCodeMappingForMtCore:
      (json['tecTacCodeMappingForMtCore'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  vrTourLink: json['vrTourLink'] as String,
  zipCode: json['zipCode'] as String,
  newCentreCodesForMtCore: (json['newCentreCodesForMtCore'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  newCentreCodesForVoCwCheckout:
      (json['newCentreCodesForVoCwCheckout'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  languageCode: json['languageCode'] as String?,
  chinaCoordinates: (json['chinaCoordinates'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  displayAddressWithLevel: Map<String, String>.from(
    json['displayAddressWithLevel'] as Map,
  ),
  netSizeSqM: (json['netSizeSqM'] as num).toDouble(),
);

Map<String, dynamic> _$CentreDtoToJson(CentreDto instance) => <String, dynamic>{
  'id': instance.id,
  'amenities': instance.amenities,
  'country': instance.country,
  'centreCodesForVoCwCheckout': instance.centreCodesForVoCwCheckout,
  'centreHighlights': instance.centreHighlights,
  'cityId': instance.cityId,
  'citySlug': instance.citySlug,
  'cityCode': instance.cityCode,
  'displayEmail': instance.displayEmail,
  'displayPhone': instance.displayPhone,
  'centreSchedule': instance.centreSchedule,
  'grossSizeSqFt': instance.grossSizeSqFt,
  'isDeleted': instance.isDeleted,
  'centreTrafficInfo': instance.centreTrafficInfo,
  'displayAddress': instance.displayAddress,
  'addressLevel': instance.addressLevel,
  'localizedName': instance.localizedName,
  'mapboxCoordinates': instance.mapboxCoordinates,
  'slug': instance.slug,
  'netSizeSqFt': instance.netSizeSqFt,
  'noOfFloors': instance.noOfFloors,
  'noOfMeetingRoom': instance.noOfMeetingRoom,
  'sequence': instance.sequence,
  'status': instance.status,
  'tecTacCodeMappingForMtCore': instance.tecTacCodeMappingForMtCore,
  'vrTourLink': instance.vrTourLink,
  'zipCode': instance.zipCode,
  'newCentreCodesForMtCore': instance.newCentreCodesForMtCore,
  'newCentreCodesForVoCwCheckout': instance.newCentreCodesForVoCwCheckout,
  'languageCode': instance.languageCode,
  'chinaCoordinates': instance.chinaCoordinates,
  'displayAddressWithLevel': instance.displayAddressWithLevel,
  'netSizeSqM': instance.netSizeSqM,
};
