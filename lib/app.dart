import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/theme/app_theme.dart';
import 'package:my_tec_listing_module_app/domain/entities/meeting_room_entity.dart';
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

