import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentCityStateProvider = StateProvider<CityState>((ref) {
  return CityState(cityCode: 'HKG', cityName: 'Hong Kong');
});

class CityState {
  final String cityName;
  final String cityCode;

  CityState({required this.cityName, required this.cityCode});
}
