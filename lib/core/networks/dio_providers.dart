import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
        headers: {'Accept': '*/*', 'x-access-key': const String.fromEnvironment('ACCESS_KEY')},
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('REQUEST PATH ${options.method} => ${options.path}');
            debugPrint('REQUEST QUERY PARAMETERS => ${options.queryParameters}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            debugPrint('RESPONSE DATA => ${response.data}');
            return handler.next(response);
          },
          onError: (DioException error, handler) {
            debugPrint('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
            debugPrint('ERROR MESSAGE => ${error.message}');
            return handler.next(error);
          },
        ),
      );
    }
    return;
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
        headers: {'Accept': '*/*', 'x-access-key': const String.fromEnvironment('ACCESS_KEY')},
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
          // debugPrint('RESPONSE DATA => ${response.data}');
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