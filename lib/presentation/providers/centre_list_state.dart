import 'package:my_tec_listing_module_app/data/api/core_api_service.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'centre_list_state.g.dart';

@riverpod
class CentreListState extends _$CentreListState {
  @override
  Future<List<CentreDto>> build() async {
    final CoreApiService coreApiService = ref.read(coreApiServiceProvider);
    final response = await coreApiService.getCentres();
    return response;
  }
}