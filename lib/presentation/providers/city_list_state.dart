
import 'package:my_tec_listing_module_app/data/api/core_api_service.dart';
import 'package:my_tec_listing_module_app/data/dto/city_dto.dart';
import 'package:my_tec_listing_module_app/data/dto/responses/get_cities_response_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'city_list_state.g.dart';

@riverpod
class CityListState extends _$CityListState {
  @override
  FutureOr<List<CityDto>> build() async {
    ref.keepAlive();
    final CoreApiService coreApiService = ref.read(coreApiServiceProvider);
    final GetCitiesResponseDto cities = await coreApiService.getCities(pageSize: 50);

    return cities.items;
  }
}


// CITY example
// {
//   "cityId": 35249,
//   "countryId": 606,
//   "code": "HKG",
//   "name": "Hong Kong",
//   "timeZone": {
//       "displayName": "(UTC+08:00) GMT+08:00",
//       "standardName": "GMT+08:00",
//       "baseUtcOffset": "08:00:00"
//   },
//   "isActive": true,
//   "accountEmail": "test-hongkong-account@executivecentre.com.invalid",
//   "currencyIsoCode": "HKD",
//   "generalEmail": "test-hongkong-general@executivecentre.com.invalid",
//   "generalPhone": "+852 2297 0222",
//   "meEmail": "test-hongkong-mr@executivecentre.com.invalid",
//   "nameTranslation": {
//       "en": "Hong Kong",
//       "jp": "香港",
//       "kr": "홍콩",
//       "zhHans": "香港",
//       "zhHant": "香港"
//   },
//   "paymentGateway": "TEC_Payment_Gateway",
//   "paymentMethod": "Visa;MasterCard;JCB;American Express",
//   "sequence": 2,
//   "voCwEmail": "test-hongkong-cwvo@executivecentre.com.invalid",
//   "bdGroupEmail": "test-hongkong-bdgroupl@executivecentre.com.invalid",
//   "region": {
//       "id": "a3QBW00000000jB2AQ",
//       "name": {
//           "en": "Greater China",
//           "jp": "中華圏",
//           "kr": "중화권",
//           "zhHans": "大中华",
//           "zhHant": "大中華"
//       }
//   }
// },