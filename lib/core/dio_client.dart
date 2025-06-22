import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DioClient {
  late final Dio _dio;
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://octo.pr-product-core.executivecentre.net/core-api/api/v1/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {'Accept': '*/*', 'x-access-key': 'qui_aute_fugiat_irure'},
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.uri}');
          print('REQUEST BODY => ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          print('RESPONSE DATA => ${response.data}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          print('ERROR MESSAGE => ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}

final dioProvider = Provider<DioClient>((ref) {
  return DioClient();
});


// qui_aute_fugiat_irure
// {{ProfileId}}