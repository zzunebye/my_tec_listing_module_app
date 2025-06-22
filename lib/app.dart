import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/presentation/providers/centre_list_state.dart';
import 'package:my_tec_listing_module_app/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/screens/splash_screen.dart';

class MyTECApp extends HookConsumerWidget {
  const MyTECApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final centreList = ref.watch(centreListStateProvider);
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
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
    inputDecorationTheme: AppTheme.inputDecorationTheme,
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      labelStyle: TextStyle(color: Colors.black, fontSize: 12.0),
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      labelPadding: EdgeInsets.only(left: 2.0, right: 4.0),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
    inputDecorationTheme: AppTheme.inputDecorationTheme,
  );
  static final inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
    labelStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
  
  );
}
