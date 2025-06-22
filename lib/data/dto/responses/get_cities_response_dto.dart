import 'package:json_annotation/json_annotation.dart';
import 'package:my_tec_listing_module_app/data/dto/city_dto.dart';

part 'get_cities_response_dto.g.dart';

@JsonSerializable()
class GetCitiesResponseDto {
  final List<CityDto> items;
  final int pageCount;
  final int totalItemCount;
  final int pageNumber;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final bool isFirstPage;
  final bool isLastPage;
  GetCitiesResponseDto({
    required this.items,
    required this.pageCount,
    required this.totalItemCount,
    required this.pageNumber,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.isFirstPage,
    required this.isLastPage,
  });

  factory GetCitiesResponseDto.fromJson(Map<String, dynamic> json) => _$GetCitiesResponseDtoFromJson(json);

  Map<String,dynamic> toJson() => _$GetCitiesResponseDtoToJson(this);
}


