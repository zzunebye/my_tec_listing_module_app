import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/data/dto/meeting_room_pricing_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/get_cities_response_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/meeting_room_response_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/dio_client.dart';

// import '../core/config/api_endpoints.dart';
// import '../models/room_model.dart';
// import '../models/centre_model.dart';
// import '../models/city_model.dart';

part 'booking_api_service.g.dart';

@riverpod
MeetingRoomApiService bookingApiService(Ref ref) {
  return MeetingRoomApiService(ref.watch(dioProvider));
}

class MeetingRoomApiEndpoints {
  static const String baseUrl = 'https://octo.pr-product-core.executivecentre.net/core-api/api/v1/';

  // Room endpoints
  static const String roomAvailabilities = 'meetingrooms/availabilities';
  static const String roomPricings = 'meetingrooms/pricings';
  static const String meetingRooms = 'meetingrooms';

  // Location endpoints
  static const String centreGroups = 'centregroups';
  static const String cities = 'cities';
}

class MeetingRoomApiService {
  final DioClient _dioClient;

  MeetingRoomApiService(this._dioClient);

  Future<List<Map>> getAvailableRooms({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
  }) async {
    final response = await _dioClient.dio.get(
      MeetingRoomApiEndpoints.roomAvailabilities,
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'cityCode': cityCode,
      },
    );

    final List<Map> data = response.data['data'] ?? response.data;
    return data;
  }

  Future<List<MeetingRoomPricingDto>> getRoomPricing({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
    bool isVcBooking = false,
    String? profileId,
  }) async {
    final response = await _dioClient.dio.get(
      MeetingRoomApiEndpoints.roomPricings,
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'cityCode': cityCode,
        'isVcBooking': isVcBooking,
        if (profileId != null) 'profileId': profileId,
      },
    );

    final List<MeetingRoomPricingDto> pricing = response.data['data'] ?? response.data;

    return pricing;
  }

  Future<MeetingRoomResponseDto> getAllRooms({int pageSize = 10, int pageNumber = 1}) async {
    final response = await _dioClient.dio.get(
      MeetingRoomApiEndpoints.meetingRooms,
      queryParameters: {'pageSize': pageSize, 'pageNumber': pageNumber},
    );

    final MeetingRoomResponseDto rooms = MeetingRoomResponseDto.fromJson(response.data['data'] ?? response.data);

    return rooms;
  }

  Future<List<Map>> getCentres() async {
    final response = await _dioClient.dio.get(MeetingRoomApiEndpoints.centreGroups);
    final List<Map> data = response.data['data'] ?? response.data;
    return data;
  }

  Future<GetCitiesResponseDto> getCities({int pageSize = 10, int pageNumber = 1}) async {
    final response = await _dioClient.dio.get(
      MeetingRoomApiEndpoints.cities,
      queryParameters: {'pageSize': pageSize, 'pageNumber': pageNumber},
    );

    final GetCitiesResponseDto data = GetCitiesResponseDto.fromJson(response.data['data'] ?? response.data);
    return data;
  }
}
