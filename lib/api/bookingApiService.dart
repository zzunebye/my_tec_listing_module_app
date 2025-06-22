import '../core/dio_client.dart';

// import '../core/config/api_endpoints.dart';
// import '../models/room_model.dart';
// import '../models/centre_model.dart';
// import '../models/city_model.dart';
class ApiEndpoints {
  static const String baseUrl = 'https://octo.pr-product-core.executivecentre.net/core-api-me/api/v1/';

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
      ApiEndpoints.roomAvailabilities,
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'cityCode': cityCode,
      },
    );

    final List<Map> data = response.data['data'] ?? response.data;
    return data;
  }

  Future<List<dynamic>> getRoomPricing({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
    bool isVcBooking = false,
    String? profileId,
  }) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.roomPricings,
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'cityCode': cityCode,
        'isVcBooking': isVcBooking,
        if (profileId != null) 'profileId': profileId,
      },
    );

    return response.data['data'] ?? response.data;
  }

  Future<List<Map>> getAllRooms({int pageSize = 10, int pageNumber = 1}) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.meetingRooms,
      queryParameters: {'pageSize': pageSize, 'pageNumber': pageNumber},
    );

    final List<Map> data = response.data['data'] ?? response.data;
    return data;
  }

  Future<List<Map>> getCentres() async {
    final response = await _dioClient.dio.get(ApiEndpoints.centreGroups);
    final List<Map> data = response.data['data'] ?? response.data;
    return data;
  }

  Future<List<Map>> getCities({int pageSize = 10, int pageNumber = 1}) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.cities,
      queryParameters: {'pageSize': pageSize, 'pageNumber': pageNumber},
    );

    final List<Map> data = response.data['data'] ?? response.data;
    return data;
  }
}
