import 'package:my_tec_listing_module_app/data/api/core_me_api_service.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'centre_list_state.g.dart';

@riverpod
class CentreListState extends _$CentreListState {
  @override
  Future<List<CentreDto>> build() async {
    final CoreMeApiService coreMeApiService = ref.read(coreMeApiServiceProvider);
    // final filter = ref.watch(meetingRoomFilterStateProvider);
    // print('filter: ${filter.centres}');
    // final currentCity = ref.watch(currentCityStateProvider);
    final response = await coreMeApiService.getCentres();
    return response;
  }

  Future<List<CentreDto>> getCentresByCity(String cityCode) async {
    if (state.hasValue) {
      return state.value!.where((centre) => centre.cityCode == cityCode).toList();
    }
    return [];
  }
}
