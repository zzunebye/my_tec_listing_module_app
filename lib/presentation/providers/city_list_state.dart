import 'package:my_tec_listing_module_app/data/api/core_api_service.dart';
import 'package:my_tec_listing_module_app/data/dto/city_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/get_cities_response_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'city_list_state.g.dart';

@riverpod
class CityListState extends _$CityListState {
  @override
  FutureOr<List<CityDto>> build() async {
    ref.keepAlive();
    final CoreApiService coreApiService = ref.read(coreApiServiceProvider);
    final GetCitiesResponseDto cities = await coreApiService.getCities(pageSize: 50);

    return cities.items;
  }
}

