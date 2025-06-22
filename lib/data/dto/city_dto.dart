import 'package:json_annotation/json_annotation.dart';
import 'package:my_tec_listing_module_app/data/dto/name_translation_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/region_dto.dart';

part 'city_dto.g.dart';

@JsonSerializable()
class CityDto {
  final int cityId;
  final int countryId;
  final String code;
  final String name;
  final Map<String, dynamic> timeZone;
  final bool isActive;
  final String accountEmail;
  final String currencyIsoCode;
  final String generalEmail;
  final String? generalPhone;
  final String meEmail;
  final NameTranslationDto nameTranslation;
  final String? paymentGateway;
  final String? paymentMethod;
  final int? sequence;
  final String voCwEmail;
  final String bdGroupEmail;
  final RegionDto region;

  CityDto({
    required this.cityId,
    required this.countryId,
    required this.code,
    required this.name,
    required this.timeZone,
    required this.isActive,
    required this.accountEmail,
    required this.currencyIsoCode,
    required this.generalEmail,
    required this.generalPhone,
    required this.meEmail,
    required this.nameTranslation,
    required this.paymentGateway,
    this.paymentMethod,
     this.sequence,
    required this.voCwEmail,
    required this.bdGroupEmail,
    required this.region,
  });

  factory CityDto.fromJson(Map<String, dynamic> json) => _$CityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CityDtoToJson(this);
}
