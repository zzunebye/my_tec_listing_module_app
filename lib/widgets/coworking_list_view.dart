import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/widgets/coworking_card.dart';

class CoworkingListView extends StatelessWidget {
  const CoworkingListView({super.key, required this.bookingCoworkingState});

  final List<CentreDto> bookingCoworkingState;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookingCoworkingState.length,
      itemBuilder: (BuildContext context, int index) {
        print(bookingCoworkingState[index]);
        return CoworkingCard();
      },
    );
  }
}
