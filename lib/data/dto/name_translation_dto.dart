import 'package:json_annotation/json_annotation.dart';

part 'name_translation_dto.g.dart';

@JsonSerializable()
class NameTranslationDto {
  final String? en;
  final String? jp;
  final String? kr;
  final String? zhHans;
  final String? zhHant;

  NameTranslationDto({this.en, this.jp, this.kr, this.zhHans, this.zhHant});

  factory NameTranslationDto.fromJson(Map<String, dynamic> json) => _$NameTranslationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NameTranslationDtoToJson(this);
}
