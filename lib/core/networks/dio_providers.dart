import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CoreClient {
  late final Dio _dio;
  CoreClient() {
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
          print('REQUEST PATH ${options.method} => ${options.path}');
          print('REQUEST QUERY PARAMETERS => ${options.queryParameters}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          // print('RESPONSE DATA => ${response.data}');
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

final coreDioProvider = Provider<CoreClient>((ref) {
  return CoreClient();
});

final coreMeDioProvider = Provider<Dio>((ref) {
  return Dio(
      BaseOptions(
        baseUrl: 'https://octo.pr-product-core.executivecentre.net/core-api-me/api/v1/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 12),
        headers: {'Accept': '*/*', 'x-access-key': 'qui_aute_fugiat_irure'},
      ),
    )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('REQUEST PATH ${options.method} => ${options.path}');
          debugPrint('REQUEST QUERY PARAMETERS => ${options.queryParameters}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          // print('RESPONSE DATA => ${response.data}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          debugPrint('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          debugPrint('ERROR MESSAGE => ${error.message}');
          return handler.next(error);
        },
      ),
    );
});




// qui_aute_fugiat_irure
// {{ProfileId}}