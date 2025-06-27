import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/theme/app_theme.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/utils/date.dart';

class CoworkingCard extends StatelessWidget {
  const CoworkingCard({super.key, required this.coworkingCentre, required this.filterDay});

  final CentreDto coworkingCentre;
  final DateTime filterDay;

  @override
  Widget build(BuildContext context) {
    final dayScheduleInfo = coworkingCentre.centreSchedule[getWeekdayString(filterDay.weekday).toLowerCase()];
    final isAvailableBasedOnSchedule = (dayScheduleInfo?['start'] != null || dayScheduleInfo?['end'] != null)
        ? true
        : false;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.xSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppBorderRadius.medium),
                      topRight: Radius.circular(AppBorderRadius.medium),
                    ),
                    child: ColorFiltered(
                      colorFilter: isAvailableBasedOnSchedule
                          ? const ColorFilter.mode(Colors.transparent, BlendMode.color)
                          : ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                      child: Image.asset(
                        'assets/images/tec_map_sample.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xSmall, vertical: AppSpacing.xxSmall),
                    decoration: BoxDecoration(
                      color: isAvailableBasedOnSchedule
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppBorderRadius.normal),
                        topRight: Radius.circular(AppBorderRadius.normal),
                      ),
                    ),
                    child: Text(
                      isAvailableBasedOnSchedule ? 'WALK IN ONLY' : 'CENTRE CLOSED',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isAvailableBasedOnSchedule
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isAvailableBasedOnSchedule)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xxSmall),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Available', style: Theme.of(context).textTheme.labelSmall),
                            Icon(Icons.person_outline, size: 16, color: Theme.of(context).colorScheme.primary),
                          ],
                        ),
                      ),
                    Text(
                      coworkingCentre.localizedName?['en'] ?? '',
                      // '28 Stanley Street',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 0),
                    Text(
                      '822m distance',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    coworkingCentre.amenities['freshCoffeeByProfessionalBarista'] == true
                        ? Row(
                            children: [
                              Icon(Icons.coffee_outlined, size: 16),
                              const SizedBox(width: 4),
                              Text('Baristar Bar', style: Theme.of(context).textTheme.labelMedium),
                            ],
                          )
                        : SizedBox.shrink(),
                    // const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
