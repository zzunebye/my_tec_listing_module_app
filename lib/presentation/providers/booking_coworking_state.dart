import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/centre_list_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_coworking_state.g.dart';

@riverpod
class BookingCoworkingState extends _$BookingCoworkingState {
  @override
  Future<List<CentreDto>> build() async {
    final MeetingRoomFilter filter = ref.watch(meetingRoomFilterStateProvider);
    final CityState currentCityEntity = ref.watch(currentCityStateProvider);
    // final List<CityDto> cities = await ref.watch(cityListStateProvider.future);
    final List<CentreDto> centres = await ref.watch(centreListStateProvider.future);
    final List<CentreDto> centresUnderCurrentCity = centres.where((centre) => centre.cityCode == currentCityEntity.cityCode).toList();


    return centresUnderCurrentCity;
  }
}