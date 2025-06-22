import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://octo.pr-product-core.executivecentre.net',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
