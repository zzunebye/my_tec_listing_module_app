import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/domain/repositories/meeting_room_repository.dart';

class MeetingRoomDetailScreen extends StatelessWidget {
  const MeetingRoomDetailScreen({super.key, required this.entity});
  final MeetingRoomEntity entity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Room Detail'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            Image.network(entity.photoUrls?.firstOrNull ?? ''),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {0: FlexColumnWidth(1.0)},
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Room Name: ${entity.roomName}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...[
                      {'label': 'Room Code', 'value': entity.roomCode},
                      {'label': 'Centre', 'value': entity.centreName},
                      {'label': 'Address', 'value': entity.centreAddress, 'expanded': true},
                      {'label': 'Floor', 'value': entity.floor},
                      {'label': 'Capacity', 'value': '${entity.capacity} people'},
                      {'label': 'Video Conference', 'value': entity.hasVideoConference ? "Yes" : "No"},
                      {'label': 'Bookable', 'value': entity.isBookable ? "Yes" : "No"},
                      {'label': 'Available', 'value': entity.isAvailable ? "Yes" : "No"},
                    ]
                    .map(
                      (row) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${row['label']}:', style: const TextStyle(fontWeight: FontWeight.w500)),
                                if (row['expanded'] == true)
                                  Expanded(child: Text(row['value'] as String, textAlign: TextAlign.right))
                                else
                                  Text(row['value'] as String),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                if (entity.isWithinOfficeHour != null)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Within Office Hour:', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text(entity.isWithinOfficeHour! ? "Yes" : "No"),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (entity.distance != null)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Distance:', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text('${entity.distance!.toStringAsFixed(0)}m'),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (entity.finalPrice != null && entity.currencyCode != null)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Price:', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text('${entity.finalPrice!.toStringAsFixed(2)} ${entity.currencyCode} / hour'),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (entity.bestPricingStrategyName != null)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Pricing Strategy:', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text(entity.bestPricingStrategyName!),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Amenities:'),
            if (entity.amenities.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entity.amenities.map((a) => Text('- $a')).toList(),
                ),
              )
            else
              const Padding(padding: EdgeInsets.only(left: 8.0, top: 4.0), child: Text('No amenities listed')),
            if (entity.photoUrls != null && entity.photoUrls!.isNotEmpty)
              Padding(padding: const EdgeInsets.only(top: 16.0), child: Text('Photo URLs:')),
            if (entity.photoUrls != null && entity.photoUrls!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entity.photoUrls!
                      .map((url) => Text(url, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
