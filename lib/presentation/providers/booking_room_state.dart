import 'package:my_tec_listing_module_app/data/api/core_me_api_service.dart';
import 'package:my_tec_listing_module_app/data/dto/meeting_room_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/meeting_room_response_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_room_state.g.dart';

@riverpod
class BookingRoomState extends _$BookingRoomState {
  @override
  FutureOr<List<MeetingRoomDto>> build() async {
    ref.keepAlive();
    final CoreMeApiService coreMeApiService = ref.read(coreMeApiServiceProvider);
    final MeetingRoomResponseDto rooms = await coreMeApiService.getAllRooms(pageSize: 50);

    return rooms.items;
  }
}