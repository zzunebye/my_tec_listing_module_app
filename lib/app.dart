import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
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
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      background: AppColors.background,
      onBackground: AppColors.onBackground,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: AppColors.onError,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppBorderRadius.large)),
      // constraints: BoxConstraints(maxHeight: 40.0),
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: AppSpacing.xSmall),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      iconColor: AppColors.subtitle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
      ),
    ),
    tabBarTheme: TabBarThemeData(
      tabAlignment: TabAlignment.start,
      labelColor: AppColors.onSurface,
      labelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelColor: AppColors.subtitle,
      labelPadding: EdgeInsets.symmetric(horizontal: AppSpacing.small),
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primary, width: 1.0)),
        shape: BoxShape.rectangle,
      ),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColors.primary,
    ),

    chipTheme: ChipThemeData(
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.subtitle, size: 18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.large)),
      labelStyle: TextStyle(color: AppColors.onSurface),
      backgroundColor: AppColors.surface,
    ),
    textTheme: const TextTheme(
    ),
    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.divider,
    disabledColor: AppColors.disabled,
    // Primary Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.medium)),
      ),
    ),
    // Secondary Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 3,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        side: BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.medium)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.medium)),
      ),
    ),

    // chipTheme: chipTheme,
    appBarTheme: appBarTheme,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, brightness: Brightness.dark),
    chipTheme: chipTheme,
    inputDecorationTheme: AppTheme.inputDecorationTheme,
    appBarTheme: appBarTheme,
  );
  static final inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppBorderRadius.large)),
    constraints: BoxConstraints(maxHeight: 40.0),
    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: AppSpacing.xSmall),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.border),
      borderRadius: BorderRadius.circular(24.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.border),
      borderRadius: BorderRadius.circular(24.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
      borderRadius: BorderRadius.circular(24.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
      borderRadius: BorderRadius.circular(24.0),
    ),
  );
}

final appBarTheme = AppBarTheme(backgroundColor: Colors.white, elevation: 1, shadowColor: AppColors.border);
final chipTheme = ChipThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.large)),
  labelStyle: TextStyle(color: Colors.black, fontSize: 12.0),
  backgroundColor: Colors.white,
  // padding: EdgeInsets.symmetric(horizontal: 4.0),
  // labelPadding: EdgeInsets.only(left: 0.0, right: 4.0),
);

// primitive_colors.dart
class PrimitiveColors {
  static const navy500 = Color(0xFF0D1B3C); // 버튼/헤더/아이콘 등
  static const navy700 = Color(0xFF091022); // 더 어두운 텍스트
  static const gold400 = Color(0xFFFFC700); // 골드 마커
  static const white = Color(0xFFFFFFFF); // 텍스트 onPrimary 등
  static const black = Color(0xFF000000); // 텍스트 대비용
  static const grey50 = Color(0xFFF9F9F9); // 전체 배경
  static const grey100 = Color(0xFFF2F2F2); // 카드 배경
  static const grey300 = Color(0xFFE0E0E0); // 디바이더
  static const grey600 = Color(0xFF757575); // 중간 텍스트
  static const grey900 = Color(0xFF212121); // 본문 텍스트
  static const blueAccent = Color(0xFF0066FF); // 링크 색상
  static const red = Color(0xFFD32F2F); // 에러 색상
}

class AppColors {
  static const primary = Color(0xFF0D1B3C);
  static const onPrimary = Color(0xFFFFFFFF);

  static const secondary = Color(0xFFFFC700);
  static const onSecondary = Color(0xFF000000);

  static const background = Color(0xFFF9F9F9);
  static const onBackground = Color(0xFF212121);

  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF212121);

  static const error = Color(0xFFB00020);
  static const onError = Color(0xFFFFFFFF);

  static const divider = Color(0xFFE0E0E0);
  static const disabled = Color(0xFFBDBDBD);

  static const subtitle = Color(0xFF616161);
  static const link = Color(0xFF0066FF);
  static const marker = secondary;

  static const border = PrimitiveColors.grey300; // 카드 구분선
}
