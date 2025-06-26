import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/app.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/grouped_city_list_state.dart';

class CitySelectionDialog extends HookConsumerWidget {
  const CitySelectionDialog({super.key, required this.onCitySaved, required this.currentCity});

  final Function(String cityName, String cityCode) onCitySaved;
  final CityState currentCity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Extract outside the widget, inject from page widget
    final cityListState = ref.watch(groupedCityListStateProvider);

    final localCurrentCity = useState<String>(currentCity.cityName);
    final localCurrentCityCode = useState<String>(currentCity.cityCode);

    return AlertDialog(
      title: Column(
        children: [
          Text('Location', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: AppSpacing.xxSmall),
          Text(
            'Please select your location',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: AppSpacing.xSmall),
          cityListState.when(
            data: (List<RegionWithCitiesEntity> regions) {
              final groupedEntries = <DropdownMenuEntry<String>>[];

              // Add region name as separator (disabled) and its respective cities in order
              for (final region in regions) {
                groupedEntries.add(
                  DropdownMenuEntry<String>(
                    value: 'header__${region.getRegionDisplayName()}',
                    label: region.getRegionDisplayName(),
                    enabled: false,
                    style: MenuItemButton.styleFrom(
                      backgroundColor: Colors.blueGrey[100],
                      visualDensity: VisualDensity.compact,
                      disabledForegroundColor: PrimitiveColors.grey900,
                      padding: EdgeInsets.only(left: AppSpacing.small),
                      textStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: PrimitiveColors.black),
                    ),
                  ),
                );

                for (final city in region.cities) {
                  groupedEntries.add(
                    DropdownMenuEntry<String>(
                      value: city.code,
                      label: city.name,
                      style: MenuItemButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.border, width: 0.5)),
                        padding: EdgeInsets.only(
                          left: AppSpacing.large,
                          top: AppSpacing.xSmall,
                          bottom: AppSpacing.xSmall,
                        ),
                      ),
                    ),
                  );
                }
              }

              return DropdownMenu<String>(
                key: const Key('city-dropdown'),
                initialSelection: localCurrentCityCode.value,
                width: MediaQuery.of(context).size.width * 0.7,
                label: const Text('Select City'),
                menuStyle: MenuStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.medium)),
                  ),
                  visualDensity: VisualDensity.comfortable,
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: AppSpacing.large)),
                ),
                textStyle: Theme.of(context).textTheme.labelLarge,
                menuHeight: 300,
                trailingIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                selectedTrailingIcon: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                dropdownMenuEntries: groupedEntries,
                onSelected: (String? value) {
                  // Ignore header selections
                  if (value != null && !value.startsWith('header__')) {
                    // Find the selected city
                    for (final region in regions) {
                      try {
                        final selectedCity = region.cities.firstWhere((city) => city.code == value);
                        localCurrentCity.value = selectedCity.name;
                        localCurrentCityCode.value = selectedCity.code;
                        break;
                      } catch (e) {
                        // City not found in this region, continue to next region
                        continue;
                      }
                    }
                  }
                },
              );
            },
            error: (error, stackTrace) => SizedBox(),
            loading: () => SizedBox(),
          ),
        ],
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                onCitySaved("Hong Kong", "HKG");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select Nearest City'),
                  SizedBox(width: 8),
                  Transform.translate(
                    offset: Offset(0, -2),
                    child: Transform.rotate(
                      angle: 90 * 3.14 / 360,
                      child: Icon(
                        Icons.navigation_outlined,
                        size: 18.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onCitySaved(localCurrentCity.value, localCurrentCityCode.value);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
