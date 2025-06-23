import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/data/dto/city_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/city_list_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';

class CitySelectionDialog extends HookConsumerWidget {
  const CitySelectionDialog({super.key, required this.onCitySaved, required this.currentCity});

  final Function(String cityName, String cityCode) onCitySaved;
  final CityState currentCity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Extract outside the widget, inject from page widget
    final cityListState = ref.watch(cityListStateProvider);

    final localCurrentCity = useState<String>(currentCity.cityName);
    final localCurrentCityCode = useState<String>(currentCity.cityCode);

    return AlertDialog(
      title: Column(
        children: [
          Text('Location', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Text('Please select your location', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          cityListState.when(
            // items: ['a', 'b', 'c'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            data: (List<CityDto> cities) => DropdownButtonFormField<String>(
              key: const Key('city-dropdown'),
              value: currentCity.cityCode,
              items: cities.map((city) => DropdownMenuItem(value: city.code, child: Text(city.name))).toList(),

              // items: ['a', 'b', 'c'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (String? value) {
                localCurrentCity.value = cities.firstWhere((e) => e.code == value).name;
                localCurrentCityCode.value = cities.firstWhere((e) => e.code == value).code;
              },
            ),
            error: (error, stackTrace) => SizedBox(),
            loading: () => SizedBox(),
          ),
          // TextFormField(
          //   decoration: const InputDecoration(labelText: 'Area', hintText: 'Enter area/district'),
          // ),
        ],
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onCitySaved("Hong Kong", "HKG");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select Nearest City', style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(width: 8),
                  Icon(Icons.location_on, size: 18.0, color: Theme.of(context).colorScheme.onSurface),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                onCitySaved(localCurrentCity.value, localCurrentCityCode.value);
              },
              child: Text('Save', style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ],
    );
  }
}
