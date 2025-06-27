import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/coworking_card.dart';

class CoworkingListView extends StatelessWidget {
  const CoworkingListView({super.key, required this.bookingCoworkingState, required this.searchFilter});

  final List<CentreDto> bookingCoworkingState;
  final MeetingRoomFilter searchFilter;

  @override
  Widget build(BuildContext context) {
    final filterDay = searchFilter.date;

    return ListView.builder(
      itemCount: bookingCoworkingState.length,
      itemBuilder: (BuildContext context, int index) {
        return CoworkingCard(coworkingCentre: bookingCoworkingState[index], filterDay: filterDay);
      },
    );
  }
}
