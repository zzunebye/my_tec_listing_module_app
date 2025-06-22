import 'package:json_annotation/json_annotation.dart';

part 'centre_dto.g.dart';

@JsonSerializable()
class CentreDto {
  final String id;
  final Map<String, bool> amenities;
  final String country;
  final List<String> centreCodesForVoCwCheckout;
  final Map<String, String?> centreHighlights;
  final String cityId;
  final String citySlug;
  final String cityCode;
  final String displayEmail;
  final String displayPhone;
  final Map<String, Map<String, String?>?> centreSchedule;
  final int? grossSizeSqFt;
  final bool isDeleted;
  final Map<String, String?> centreTrafficInfo;
  final Map<String, String?> displayAddress;
  final String addressLevel;
  final Map<String, String?> localizedName;
  final Map<String, double> mapboxCoordinates;
  final String slug;
  final int netSizeSqFt;
  final int noOfFloors;
  final int noOfMeetingRoom;
  final Map<String, String?> sequence;
  final String status;
  final List<String> tecTacCodeMappingForMtCore;
  final String vrTourLink;
  final String zipCode;
  final List<String> newCentreCodesForMtCore;
  final List<String> newCentreCodesForVoCwCheckout;
  final String? languageCode;
  final Map<String, double> chinaCoordinates;
  final Map<String, String> displayAddressWithLevel;
  final double netSizeSqM;

  CentreDto({
    required this.id,
    required this.amenities,
    required this.country,
    required this.centreCodesForVoCwCheckout,
    required this.centreHighlights,
    required this.cityId,
    required this.citySlug,
    required this.cityCode,
    required this.displayEmail,
    required this.displayPhone,
    required this.centreSchedule,
    required this.grossSizeSqFt,
    required this.isDeleted,
    required this.centreTrafficInfo,
    required this.displayAddress,
    required this.addressLevel,
    required this.localizedName,
    required this.mapboxCoordinates,
    required this.slug,
    required this.netSizeSqFt,
    required this.noOfFloors,
    required this.noOfMeetingRoom,
    required this.sequence,
    required this.status,
    required this.tecTacCodeMappingForMtCore,
    required this.vrTourLink,
    required this.zipCode,
    required this.newCentreCodesForMtCore,
    required this.newCentreCodesForVoCwCheckout,
    required this.languageCode,
    required this.chinaCoordinates,
    required this.displayAddressWithLevel,
    required this.netSizeSqM,
  });

  factory CentreDto.fromJson(Map<String, dynamic> json) => _$CentreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CentreDtoToJson(this);
}
