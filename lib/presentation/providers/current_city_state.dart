import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentCityStateProvider = StateProvider<String>((ref) {
  return 'Hong Kong';
});