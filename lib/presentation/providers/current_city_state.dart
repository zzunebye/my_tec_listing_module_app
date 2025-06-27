import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/centre_list_state.dart';

final centresUnderCurrentCityProvider = FutureProvider<List<CentreDto>>((ref) async {
  final currentCity = ref.watch(currentCityStateProvider);
  final centres = await ref.watch(centreListStateProvider.future);
  return centres.where((centre) => centre.cityCode == currentCity.cityCode).toList();
});


final currentCityStateProvider = StateProvider<CityState>((ref) {
  return CityState(cityCode: 'HKG', cityName: 'Hong Kong');
});

class CityState {
  final String cityName;
  final String cityCode;

  CityState({required this.cityName, required this.cityCode});
}
