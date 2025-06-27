import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/domain/entities/grouped_meeting_room_entity.dart';
import 'package:my_tec_listing_module_app/domain/entities/meeting_room_entity.dart';
import 'package:my_tec_listing_module_app/domain/repositories/meeting_room_repository.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_meeting_room_state.g.dart';

@riverpod
class SearchMeetingRoomState extends _$SearchMeetingRoomState {
  @override
  FutureOr<List<GroupedMeetingRoomEntity>> build() async {
    final repository = ref.read(meetingRoomRepositoryProvider);

    final CityState currentCityEntity = ref.watch(currentCityStateProvider);
    final filter = ref.watch(meetingRoomFilterStateProvider);

    final List<CentreDto> centresUnderCurrentCity = await ref.watch(centresUnderCurrentCityProvider.future);

    final meetingRooms = await repository.getMeetingRooms(
      filter,
      centresUnderCurrentCity,
      cityCode: currentCityEntity.cityCode,
    );
    return meetingRooms;
  }
}

class SearchMeetingRoomStateEntity {
  final List<MeetingRoomEntity> meetingRooms;

  SearchMeetingRoomStateEntity({required this.meetingRooms});
}
