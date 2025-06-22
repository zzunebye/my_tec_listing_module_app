import 'package:flutter/material.dart';
import 'package:my_tec_listing_module_app/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/screens/splash_screen.dart';

class MyTECApp extends StatelessWidget {
  const MyTECApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEC Booking',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      supportedLocales: const [Locale('en', 'US')],
      initialRoute: '/splash',
      routes: {'/splash': (context) => const SplashScreen(), '/booking-list': (context) => const BookingListScreen()},
    );
  }
}

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
  );
}
