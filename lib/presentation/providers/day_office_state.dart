import 'package:my_tec_listing_module_app/data/api/core_api_service.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'day_office_state.g.dart';

@riverpod
class DayOfficeListState extends _$DayOfficeListState {
  @override
  FutureOr<List<CentreDto>> build() async {
    final filter = ref.watch(meetingRoomFilterStateProvider);
    final CoreApiService coreApiService = ref.read(coreApiServiceProvider);
    final response = await coreApiService.getCentres();
    return response;
  }
}