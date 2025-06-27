import 'package:flutter/material.dart';

class AppSpacing {
  static const double xxSmall = 4.0;
  static const double xSmall = 8.0;
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xLarge = 32.0;
}

class AppBorderRadius {
  static const double small = 8.0;
  static const double normal = 12.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xLarge = 32.0;
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
    textTheme: appTextTheme,
    chipTheme: ChipThemeData(
      elevation: 1,
      labelStyle: appTextTheme.labelSmall?.copyWith(color: AppColors.onSurface),
      iconTheme: IconThemeData(color: AppColors.subtitle, size: 18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.large)),
      labelPadding: EdgeInsets.only(right: 8),
      padding: EdgeInsets.zero,
      backgroundColor: AppColors.surface,
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
    colorScheme: const ColorScheme.dark(
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.onPrimary,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.onSecondary,
      background: AppColorsDark.background,
      onBackground: AppColorsDark.onBackground,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.onSurface,
      error: AppColorsDark.error,
      onError: AppColorsDark.onError,
      outline: AppColorsDark.border,
      outlineVariant: AppColorsDark.border,
    ),
    textTheme: appTextTheme,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppBorderRadius.normal)),
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: AppSpacing.xSmall),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      iconColor: AppColorsDark.subtitle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsDark.border),
        borderRadius: BorderRadius.circular(AppBorderRadius.normal),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsDark.border),
        borderRadius: BorderRadius.circular(AppBorderRadius.normal),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsDark.error),
        borderRadius: BorderRadius.circular(AppBorderRadius.normal),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsDark.error),
        borderRadius: BorderRadius.circular(AppBorderRadius.normal),
      ),
    ),
    tabBarTheme: TabBarThemeData(
      tabAlignment: TabAlignment.start,
      labelColor: AppColorsDark.onSurface,
      labelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelColor: AppColorsDark.subtitle,
      labelPadding: EdgeInsets.symmetric(horizontal: AppSpacing.small),
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColorsDark.primary, width: 1.0)),
        shape: BoxShape.rectangle,
      ),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColorsDark.primary,
    ),
    chipTheme: ChipThemeData(
      elevation: 1,
      iconTheme: IconThemeData(color: AppColorsDark.subtitle, size: 18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.large)),
      labelStyle: TextStyle(color: AppColorsDark.onSurface),
      backgroundColor: AppColorsDark.surface,
    ),
    scaffoldBackgroundColor: AppColorsDark.background,
    dividerColor: AppColorsDark.divider,
    disabledColor: AppColorsDark.disabled,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDark.primary,
        foregroundColor: AppColorsDark.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.medium)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 3,
        backgroundColor: AppColorsDark.surface,
        foregroundColor: AppColorsDark.onSurface,
        side: BorderSide(color: AppColorsDark.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.medium)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColorsDark.primary,
        foregroundColor: AppColorsDark.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.medium)),
      ),
    ),
    appBarTheme: darkAppBarTheme,
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
final darkAppBarTheme = AppBarTheme(
  backgroundColor: AppColorsDark.surface,
  elevation: 1,
  shadowColor: AppColorsDark.border,
);

final chipTheme = ChipThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.large)),
  labelStyle: TextStyle(color: Colors.black, fontSize: 12.0),
  backgroundColor: Colors.white,
  // padding: EdgeInsets.symmetric(horizontal: 4.0),
  // labelPadding: EdgeInsets.only(left: 0.0, right: 4.0),
);

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

class AppColorsDark {
  static const primary = Color(0xFF4A6A91);
  static const onPrimary = Color(0xFF000000);

  static const secondary = Color(0xFFFFC700);
  static const onSecondary = Color(0xFF000000);

  static const background = Color(0xFF121212);
  static const onBackground = Color(0xFFE0E0E0);

  static const surface = Color(0xFF1E1E1E);
  static const onSurface = Color(0xFFE0E0E0);

  static const error = Color(0xFFCF6679);
  static const onError = Color(0xFF000000);

  static const divider = Color(0xFF424242);
  static const disabled = Color(0xFF616161);

  static const subtitle = Color(0xFFBDBDBD);
  static const link = Color(0xFF64B5F6);
  static const marker = secondary;

  static const border = Color(0xFF424242);
}

const appTextTheme = TextTheme();
