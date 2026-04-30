import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.bodyFont,

      // Material 3 Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        scrim: AppColors.scrimColor,
        surfaceTint: AppColors.surfaceTint,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        shadowColor: AppColors.outline.withValues(alpha: 0.1),
        surfaceTintColor: AppColors.surfaceTint,
        iconTheme: const IconThemeData(color: AppColors.primary),
        titleTextStyle: AppTextStyles.headlineMedium,
      ),

      // Text Theme (using centralized AppTextStyles)
      textTheme: _textThemeFor(
        primaryTextColor: AppColors.onSurface,
        secondaryTextColor: AppColors.onSurfaceVariant,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.outline),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.onSurface,
        ),
        helperStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.outline),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.labelLarge,
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: AppTextStyles.labelMedium,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        color: AppColors.surface,
        shadowColor: AppColors.outline.withValues(alpha: 0.1),
        surfaceTintColor: AppColors.primary.withValues(alpha: 0.03),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerLow,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.surfaceContainer,
        labelStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.onSurface,
        ),
        secondaryLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.outlineVariant),
        ),
        side: const BorderSide(color: AppColors.outlineVariant),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // FAB Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: 8,
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: AppTextStyles.headlineMedium,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 0,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.5);
          }
          return AppColors.surfaceVariant;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(color: AppColors.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceVariant,
        circularTrackColor: AppColors.surfaceVariant,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inverseSurface,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 6,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surfaceTint,
        shadowColor: AppColors.outline,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        elevation: 3,
        modalElevation: 3,
      ),

      // Menu Theme
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.surface),
          elevation: WidgetStatePropertyAll(8),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const darkSurface = Color(0xFF1D1714);
    const darkSurfaceContainer = Color(0xFF2B2420);
    const darkSurfaceContainerHighest = Color(0xFF3A312B);
    const darkOnSurface = Color(0xFFEDE2D7);
    const darkOnSurfaceVariant = Color(0xFFCBBFB4);
    const darkOutline = Color(0xFF8B8076);
    const darkOutlineVariant = Color(0xFF4F463F);

    const colorScheme = ColorScheme.dark(
      primary: AppColors.primaryFixedDim,
      onPrimary: AppColors.onPrimaryFixed,
      primaryContainer: Color(0xFF7A3F1B),
      onPrimaryContainer: AppColors.primaryFixed,
      secondary: Color(0xFFD1C6BC),
      onSecondary: Color(0xFF332D28),
      secondaryContainer: Color(0xFF4A423C),
      onSecondaryContainer: Color(0xFFECE2D8),
      tertiary: Color(0xFFE0AAAA),
      onTertiary: Color(0xFF482020),
      tertiaryContainer: Color(0xFF653232),
      onTertiaryContainer: Color(0xFFF9DDDD),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: darkSurface,
      onSurface: darkOnSurface,
      surfaceContainerHighest: darkSurfaceContainerHighest,
      onSurfaceVariant: darkOnSurfaceVariant,
      outline: darkOutline,
      outlineVariant: darkOutlineVariant,
      inverseSurface: AppColors.surface,
      onInverseSurface: AppColors.onSurface,
      inversePrimary: AppColors.primary,
      scrim: Colors.black,
      surfaceTint: AppColors.primaryFixedDim,
    );

    final base = lightTheme;

    return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      colorScheme: colorScheme,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(color: colorScheme.primary),
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      textTheme: _textThemeFor(
        primaryTextColor: colorScheme.onSurface,
        secondaryTextColor: colorScheme.onSurfaceVariant,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: darkSurfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        helperStyle: AppTextStyles.bodySmall.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: colorScheme.error),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: darkSurfaceContainer,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        surfaceTintColor: colorScheme.surfaceTint.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: darkSurfaceContainer,
        selectedColor: colorScheme.primary,
        disabledColor: darkSurfaceContainerHighest,
        labelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onPrimary,
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: darkSurfaceContainer,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: darkSurfaceContainerHighest,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: darkSurfaceContainer,
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  static TextTheme _textThemeFor({
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: primaryTextColor,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: primaryTextColor,
      ),
      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: primaryTextColor,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: primaryTextColor,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: primaryTextColor,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: primaryTextColor,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: primaryTextColor),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: primaryTextColor),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: primaryTextColor),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: primaryTextColor),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: primaryTextColor),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: secondaryTextColor),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: primaryTextColor),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: primaryTextColor),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: primaryTextColor),
    );
  }
}
