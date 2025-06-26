import 'package:my_tec_listing_module_app/data/api/core_api_service.dart';
import 'package:my_tec_listing_module_app/data/dto/city_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/region_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/get_cities_response_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'grouped_city_list_state.g.dart';

/// Provider that groups cities by region for UI consumption
@riverpod
class GroupedCityListState extends _$GroupedCityListState {
  @override
  FutureOr<List<RegionWithCitiesEntity>> build() async {
    // Get the raw city list
    ref.keepAlive();
    final CoreApiService coreApiService = ref.read(coreApiServiceProvider);
    final GetCitiesResponseDto cities = await coreApiService.getCities(pageSize: 50);

    // Group cities by region
    final Map<String, List<CityDto>> regionGroups = {};
    final Map<String, RegionDto> regionLookup = {};

    for (final city in cities.items) {
      final regionId = city.region.id;

      // Store region for lookup
      regionLookup[regionId] = city.region;

      // Group cities by region ID
      if (regionGroups.containsKey(regionId)) {
        regionGroups[regionId]!.add(city);
      } else {
        regionGroups[regionId] = [city];
      }
    }

    // Convert to entities and sort by region name
    final groupedEntities = regionGroups.entries
        .map((entry) => RegionWithCitiesEntity(region: regionLookup[entry.key]!, cities: entry.value))
        .toList();

    // Sort regions by display name (English)
    groupedEntities.sort((a, b) => a.getRegionDisplayName().compareTo(b.getRegionDisplayName()));

    // Sort cities within each region by name
    for (final entity in groupedEntities) {
      entity.cities.sort((a, b) => a.name.compareTo(b.name));
    }

    return groupedEntities;
  }
}

/// Entity that represents a region with its associated cities
class RegionWithCitiesEntity {
  final RegionDto region;
  final List<CityDto> cities;

  RegionWithCitiesEntity({required this.region, required this.cities});

  /// Helper method to get region display name for current locale
  String getRegionDisplayName([String locale = 'en']) {
    switch (locale) {
      case 'jp':
        return region.name.jp ?? region.name.en ?? 'Unknown Region';
      case 'kr':
        return region.name.kr ?? region.name.en ?? 'Unknown Region';
      case 'zhHans':
        return region.name.zhHans ?? region.name.en ?? 'Unknown Region';
      case 'zhHant':
        return region.name.zhHant ?? region.name.en ?? 'Unknown Region';
      default:
        return region.name.en ?? 'Unknown Region';
    }
  }
}
