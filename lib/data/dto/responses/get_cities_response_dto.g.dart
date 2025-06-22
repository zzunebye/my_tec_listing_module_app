// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cities_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCitiesResponseDto _$GetCitiesResponseDtoFromJson(
  Map<String, dynamic> json,
) => GetCitiesResponseDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => CityDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageCount: (json['pageCount'] as num).toInt(),
  totalItemCount: (json['totalItemCount'] as num).toInt(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
  isFirstPage: json['isFirstPage'] as bool,
  isLastPage: json['isLastPage'] as bool,
);

Map<String, dynamic> _$GetCitiesResponseDtoToJson(
  GetCitiesResponseDto instance,
) => <String, dynamic>{
  'items': instance.items,
  'pageCount': instance.pageCount,
  'totalItemCount': instance.totalItemCount,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
  'isFirstPage': instance.isFirstPage,
  'isLastPage': instance.isLastPage,
};
