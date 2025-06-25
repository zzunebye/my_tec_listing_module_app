import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/domain/repositories/meeting_room_repository.dart';
import 'package:my_tec_listing_module_app/presentation/providers/centre_list_state.dart';
import 'package:my_tec_listing_module_app/screens/booking_list_screen.dart';
import 'package:my_tec_listing_module_app/screens/meeting_room_detail_screen.dart';
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
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/booking-list': (context) => const BookingListScreen(),
        '/meeting-room-detail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is MeetingRoomEntity) {
            return MeetingRoomDetailScreen(entity: args);
          }
          // Fallback: show an error or a blank screen
          return const Scaffold(body: Center(child: Text('No meeting room data provided')));
        },
      },
    );
  }
}

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
    inputDecorationTheme: AppTheme.inputDecorationTheme,
    chipTheme: chipTheme,
    appBarTheme: appBarTheme,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
    chipTheme: chipTheme,
    inputDecorationTheme: AppTheme.inputDecorationTheme,
    appBarTheme: appBarTheme,
  );
  static final inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
    labelStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),

    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
  );
}

final appBarTheme = AppBarTheme(
  backgroundColor: Colors.white,
  elevation: 1,
  shadowColor: Colors.grey.shade300,
);
final chipTheme = ChipThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  labelStyle: TextStyle(color: Colors.black, fontSize: 12.0),
  backgroundColor: Colors.white,
  // padding: EdgeInsets.symmetric(horizontal: 4.0),
  // labelPadding: EdgeInsets.only(left: 0.0, right: 4.0),
);
