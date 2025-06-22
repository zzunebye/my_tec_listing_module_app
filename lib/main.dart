import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/app.dart';
import 'package:my_tec_listing_module_app/core/dio_client.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    Provider(create: (_) => DioClient()),
  ], child: const MyTECApp()));
}
