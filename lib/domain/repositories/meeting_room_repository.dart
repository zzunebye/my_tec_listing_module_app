import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/data/api/core_api_service.dart';
import 'package:my_tec_listing_module_app/data/api/core_me_api_service.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/meeting_room_pricing_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/meeting_room_response_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meeting_room_repository.g.dart';

class MeetingRoomEntity {
  final String roomCode;
  final String roomName;
  final String centreCode;
  final String centreName;
  final String centreAddress;
  final String floor;
  final int capacity;
  final bool hasVideoConference;
  final List<String> amenities;
  final List<String>? photoUrls;
  final bool isBookable;
  final bool isAvailable;
  final double? finalPrice;
  final String? currencyCode;
  final String? bestPricingStrategyName;
  final bool? isWithinOfficeHour;
  final double? distance;

  MeetingRoomEntity({
    required this.roomCode,
    required this.roomName,
    required this.centreCode,
    required this.centreName,
    required this.centreAddress,
    required this.floor,
    required this.capacity,
    required this.hasVideoConference,
    required this.amenities,
    this.photoUrls,
    required this.isBookable,
    required this.isAvailable,
    this.finalPrice,
    this.currencyCode,
    this.bestPricingStrategyName,
    this.isWithinOfficeHour,
    this.distance,
  });
}

class GroupedMeetingRoomEntity {
  final String centreName;
  final String centreCode;
  final List<MeetingRoomEntity> meetingRooms;
  final double? distance;

  GroupedMeetingRoomEntity({
    required this.centreName,
    required this.centreCode,
    required this.meetingRooms,
    this.distance,
  });
}

class MeetingRoomRepository {
  final CoreApiService _coreApiService;
  final CoreMeApiService _coreMeApiService;

  MeetingRoomRepository(this._coreApiService, this._coreMeApiService);

  Future<List<GroupedMeetingRoomEntity>> getMeetingRooms(
    MeetingRoomFilter filter,
    List<CentreDto>? cachedCentres, {
    String cityCode = 'HKG',
  }) async {
    print('flag D: $cityCode');

    // Get centres first to have centre information
    final List<CentreDto> centres = cachedCentres ?? await _coreMeApiService.getCentres();

    // newCentreCodesForMtCore can be null, but this is the reference key for the centres to the meeting rooms
    final centresMap = {for (var centre in centres) centre.newCentreCodesForMtCore.firstOrNull ?? centre.id: centre};

    // Fetch all data in parallel
    final futures = await Future.wait([
      _coreMeApiService.getAllRooms(pageSize: 100, cityCode: cityCode),
      _coreMeApiService.getAvailableRooms(startDate: filter.startTime, endDate: filter.endTime, cityCode: cityCode),
      _coreMeApiService.getRoomPricing(startDate: filter.startTime, endDate: filter.endTime, cityCode: cityCode),
    ]);

    final roomsResponse = futures[0] as MeetingRoomResponseDto;
    final availabilities = futures[1] as List<Map>;
    final pricings = futures[2] as List<MeetingRoomPricingDto>;

    // Create maps for quick lookup
    final availabilityMap = {for (var item in availabilities) item['roomCode']: item};
    final pricingMap = {for (var item in pricings) item.roomCode: item};

    final groupedMeetingRooms = roomsResponse.items.groupBy((room) => room.centreCode);

    final List<GroupedMeetingRoomEntity> groupedMeetingRoomEntities = groupedMeetingRooms.entries.map((entry) {
      final centreCode = entry.key;
      final meetingRooms = entry.value;
      final centre = centresMap[centreCode];
      // final distance = centre?.distance;
      // final distanceInMeters = distance != null ? distance * 1000 : null;

      return GroupedMeetingRoomEntity(
        centreName: centre?.localizedName?['en'] ?? centre?.id ?? 'Unknown Centre',
        centreCode: centreCode,
        meetingRooms: meetingRooms
            .map<MeetingRoomEntity>((room) {
              final availability = availabilityMap[room.roomCode];
              final pricing = pricingMap[room.roomCode];

              return MeetingRoomEntity(
                roomCode: room.roomCode,
                roomName: room.roomName,
                centreCode: room.centreCode,
                centreName: centre?.localizedName?['en'] ?? centre?.id ?? 'Unknown Centre',
                centreAddress: centre?.localizedName?['en'] ?? 'Unknown Address',
                floor: room.floor,
                capacity: room.capacity,
                hasVideoConference: room.hasVideoConference,
                amenities: room.amenities,
                photoUrls: room.photoUrls,
                isBookable: room.isBookable,
                isAvailable: availability?['isAvailable'] ?? false,
                finalPrice: pricing?.finalPrice.toDouble(),
                currencyCode: pricing?.currencyCode,
                bestPricingStrategyName: pricing?.bestPricingStrategyName,
                isWithinOfficeHour: availability?['isWithinOfficeHour'],
              );
            })
            .where((entity) {
              // Apply filters
              if (entity.capacity < filter.capacity) return false;
              if (filter.canVideoConference && !entity.hasVideoConference) return false;
              if (filter.centres.isNotEmpty && !filter.centres.contains(entity.centreName)) return false;
              // if (!entity.isBookable) return false;
              return true;
            })
            .toList(),
        // distance: distance,
      );
    }).toList();

    // Convert to entities and apply filters
    // final entities = roomsResponse.items
    //     .map((room) {
    //       final availability = availabilityMap[room.roomCode];
    //       final centre = centresMap[room.centreCode];
    //       final pricing = pricingMap[room.roomCode];

    //       return MeetingRoomEntity(
    //         roomCode: room.roomCode,
    //         roomName: room.roomName,
    //         centreCode: room.centreCode,
    //         centreName: centre?.localizedName?['en'] ?? centre?.id ?? 'Unknown Centre',
    //         centreAddress: centre?.localizedName?['en'] ?? 'Unknown Address',
    //         floor: room.floor,
    //         capacity: room.capacity,
    //         hasVideoConference: room.hasVideoConference,
    //         amenities: room.amenities,
    //         photoUrls: room.photoUrls,
    //         isBookable: room.isBookable,
    //         isAvailable: availability?['isAvailable'] ?? false,
    //         finalPrice: pricing?.finalPrice.toDouble(),
    //         currencyCode: pricing?.currencyCode,
    //         bestPricingStrategyName: pricing?.bestPricingStrategyName,
    //         isWithinOfficeHour: availability?['isWithinOfficeHour'],
    //       );
    //     })
    //     .where((entity) {
    //       // print('flag F: ${filter.centres}');
    //       // print('flag G: ${filter.centres.contains(entity.centreName)}');
    //       // Apply filters
    //       if (entity.capacity < filter.capacity) return false;
    //       if (filter.canVideoConference && !entity.hasVideoConference) return false;
    //       // if (filter.centres.isNotEmpty && !filter.centres.contains(entity.centreName)) return false;
    //       // if (!entity.isBookable) return false;

    //       return true;
    //     })
    //     .toList();

    return groupedMeetingRoomEntities;
  }
}

@riverpod
MeetingRoomRepository meetingRoomRepository(Ref ref) {
  final apiService = ref.watch(coreApiServiceProvider);
  final coreMeApiService = ref.watch(coreMeApiServiceProvider);
  return MeetingRoomRepository(apiService, coreMeApiService);
}
