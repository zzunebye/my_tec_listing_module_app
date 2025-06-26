import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_coworking_state.g.dart';

// This provider is used to search for coworking spaces under the current city and filter by the selected centres
// it depends on the current city and the selected centres
@riverpod
class SearchCoworkingState extends _$SearchCoworkingState {
  @override
  Future<List<CentreDto>> build() async {
    final CityState currentCityEntity = ref.watch(currentCityStateProvider);
    final MeetingRoomFilter filter = ref.watch(meetingRoomFilterStateProvider);

    // final List<CityDto> cities = await ref.watch(cityListStateProvider.future);
    // final List<CentreDto> centres = await ref.watch(centreListStateProvider.future);
    // final List<CentreDto> centresUnderCurrentCity = centres.where((centre) => centre.cityCode == currentCityEntity.cityCode).toList();
    final List<CentreDto> centresUnderCurrentCity = await ref.watch(centresUnderCurrentCityProvider.future);

    final List<CentreDto> centresUnderCurrentCityAndFilter = centresUnderCurrentCity.where((element) {
      return filter.centres.contains(element.localizedName?['en']);
    }).toList();

    return centresUnderCurrentCityAndFilter;
  }
}
