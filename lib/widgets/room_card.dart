import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
import 'package:my_tec_listing_module_app/domain/entities/meeting_room_entity.dart';
import 'package:my_tec_listing_module_app/utils/date.dart';

class MeetingRoomCard extends StatelessWidget {
  final MeetingRoomEntity meetingRoom;

  const MeetingRoomCard({super.key, required this.meetingRoom});

  String? get priceText {
    if (meetingRoom.finalPrice != null && meetingRoom.currencyCode != null) {
      return '${formatPriceInCurrency(meetingRoom.finalPrice!, meetingRoom.currencyCode!)} / hour';
    }
    return 'Price not available';
  }

  String? get distanceText {
    if (meetingRoom.distance != null) {
      return '${meetingRoom.centreName}, ${meetingRoom.distance!.toStringAsFixed(0)}m distance';
    }
    return meetingRoom.centreName;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/meeting-room-detail', arguments: meetingRoom);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.xSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Theme.of(context).colorScheme.outline),
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
                      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      child: ColorFiltered(
                        colorFilter: meetingRoom.isUnavailable
                            ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                            : const ColorFilter.mode(Colors.transparent, BlendMode.color),
                        child: meetingRoom.photoUrls != null && meetingRoom.photoUrls!.isNotEmpty
                            ? Image.network(
                                meetingRoom.photoUrls!.first,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/tec_map_sample.png',
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/tec_map_sample.png',
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  if (meetingRoom.isUnavailable)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xSmall,
                          vertical: AppSpacing.xxSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                        ),

                        child: Text(
                          'UNAVAILABLE',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: AppSpacing.xSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${meetingRoom.floor}, ${meetingRoom.roomName}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      if (meetingRoom.hasVideoConference) ...[
                        const SizedBox(width: AppSpacing.xSmall),
                        Icon(Icons.videocam, size: 16, color: Theme.of(context).colorScheme.primary),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    distanceText ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${meetingRoom.capacity} Seats', style: Theme.of(context).textTheme.labelSmall),

                      const SizedBox(height: AppSpacing.xSmall),
                      Text(
                        priceText ?? 'Price not available',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
