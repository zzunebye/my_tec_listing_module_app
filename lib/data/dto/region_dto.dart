import 'package:json_annotation/json_annotation.dart';
import 'package:my_tec_listing_module_app/data/dto/name_translation_dto.dart';

part 'region_dto.g.dart';

@JsonSerializable()
class RegionDto {
  final String id;
  @JsonKey(name: 'name')
  final NameTranslationDto name;

  RegionDto({required this.id, required this.name});

  factory RegionDto.fromJson(Map<String, dynamic> json) => _$RegionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionDtoToJson(this);
}
