import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/meeting_room_pricing_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/meeting_room_response_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/networks/dio_providers.dart';

part 'core_me_api_service.g.dart';

@riverpod
CoreMeApiService coreMeApiService(Ref ref) {
  return CoreMeApiService(ref.watch(coreMeDioProvider));
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

class CoreMeApiService {
  final Dio _dioClient;

  CoreMeApiService(this._dioClient);

  Future<List<Map>> getAvailableRooms({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
  }) async {
    print('params: ${startDate.toIso8601String()}, ${endDate.toIso8601String()}, $cityCode');
    try {
      final Response response = await _dioClient.get(
        CoreApiEndpoints.roomAvailabilities,
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'cityCode': cityCode,
        },
      );
      final List<Map> data = response.data.cast<Map>();

      return data;
    } on Exception catch (e, st) {
      print('error: $e');
      print('stack trace: $st');
      rethrow;
    }
  }

  Future<List<MeetingRoomPricingDto>> getRoomPricing({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
    bool isVcBooking = false,
    String? profileId = '{{ProfileId}}',
  }) async {
    final response = await _dioClient.get(
      CoreApiEndpoints.roomPricings,
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'cityCode': cityCode,
        'isVcBooking': isVcBooking,
        if (profileId != null) 'profileId': profileId,
      },
    );

    final List<MeetingRoomPricingDto> pricingList = (response.data as List<dynamic>)
        .map((e) => MeetingRoomPricingDto.fromJson(e))
        .toList();

    return pricingList;
  }

  Future<MeetingRoomResponseDto> getAllRooms({int pageSize = 10, int pageNumber = 1, String? cityCode}) async {
    final response = await _dioClient.get(
      CoreApiEndpoints.meetingRooms,
      queryParameters: {'pageSize': pageSize, 'pageNumber': pageNumber, 'cityCode': cityCode},
    );

    final MeetingRoomResponseDto rooms = MeetingRoomResponseDto.fromJson(response.data['data'] ?? response.data);

    return rooms;
  }

  Future<List<CentreDto>> getCentres() async {
    final response = await _dioClient.get(CoreApiEndpoints.centreGroups);
    final List<CentreDto> data = (response.data as List<dynamic>).map((e) => CentreDto.fromJson(e)).toList();
    return data;
  }
}
