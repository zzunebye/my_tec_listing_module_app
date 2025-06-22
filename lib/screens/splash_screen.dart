import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/presentation/providers/city_list_state.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityProvider = ref.watch(cityListStateProvider);

    print("${cityProvider}");

    ref.listen(cityListStateProvider, (previous, next) {
      if (next.value != null) {
        Navigator.pushReplacementNamed(context, '/booking-list');
      }
    });

    // Future.delayed(const Duration(milliseconds: 100), () {
    //   Navigator.pushReplacementNamed(context, '/booking-list');
    // });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or app icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.meeting_room,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            // App title
            const Text(
              'Meeting Rooms',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              'Find and book your perfect meeting space',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}