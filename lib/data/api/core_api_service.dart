import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/get_cities_response_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/networks/dio_providers.dart';

// import '../core/config/api_endpoints.dart';
// import '../models/room_model.dart';
// import '../models/centre_model.dart';
// import '../models/city_model.dart';

part 'core_api_service.g.dart';

@riverpod
CoreApiService coreApiService(Ref ref) {
  return CoreApiService(ref.watch(coreDioProvider));
}

class CoreApiEndpoints {
  static const String baseUrl = 'https://octo.pr-product-core.executivecentre.net/core-api/api/v1/';

  // Room endpoints
  static const String roomAvailabilities = 'meetingrooms/availabilities';
  static const String roomPricings = 'meetingrooms/pricings';
  static const String meetingRooms = 'meetingrooms';

  // Location endpoints
  static const String centreGroups = 'centregroups';
  static const String cities = 'cities';
}

class CoreApiService {
  final CoreClient _dioClient;

  CoreApiService(this._dioClient);

  Future<GetCitiesResponseDto> getCities({int pageSize = 10, int pageNumber = 1}) async {
    final response = await _dioClient.dio.get(
      CoreApiEndpoints.cities,
      queryParameters: {'pageSize': pageSize, 'pageNumber': pageNumber},
    );

    final GetCitiesResponseDto data = GetCitiesResponseDto.fromJson(response.data['data'] ?? response.data);
    return data;
  }
}
