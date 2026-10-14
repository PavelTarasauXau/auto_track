import 'package:flutter/material.dart';

/// "Car dashboard" palette: near-black surfaces, neon accents.
abstract final class AppColors {
  static const background = Color(0xFF07090D);
  static const surface = Color(0xFF10141C);
  static const surfaceHigh = Color(0xFF171D28);
  static const surfaceHighest = Color(0xFF1F2735);
  static const outline = Color(0xFF263042);

  static const text = Color(0xFFEAF0FF);
  static const textMuted = Color(0xFF8A94A8);

  static const cyan = Color(0xFF3DD9FF);
  static const violet = Color(0xFF7C5CFF);

  static const ok = Color(0xFF34E39A);
  static const soon = Color(0xFFFFB547);
  static const overdue = Color(0xFFFF5470);

  /// Signature gradient of buttons, rings and highlights.
  static const accent = LinearGradient(
    colors: [cyan, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Display font for numbers and headings.
const displayFont = 'SpaceGrotesk';

/// Body font (Android system font). Set explicitly on component styles
/// that replace the default text style (buttons, chips, tabs), otherwise
/// they would fall back to the engine default instead of the theme font.
const bodyFont = 'Roboto';

abstract final class AppTheme {
  static ThemeData get dark => _build();

  static ThemeData _build() {
    const scheme = ColorScheme.dark(
      primary: AppColors.cyan,
      onPrimary: Color(0xFF00161D),
      primaryContainer: Color(0xFF0D2A34),
      onPrimaryContainer: AppColors.cyan,
      secondary: AppColors.violet,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF231B47),
      onSecondaryContainer: Color(0xFFCFC3FF),
      tertiary: AppColors.violet,
      onTertiary: Colors.white,
      error: AppColors.overdue,
      onError: Color(0xFF1F0008),
      errorContainer: Color(0xFF3A1320),
      onErrorContainer: Color(0xFFFFB3C0),
      surface: AppColors.background,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.textMuted,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.surface,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceHigh,
      surfaceContainerHighest: AppColors.surfaceHighest,
      outline: AppColors.outline,
      outlineVariant: AppColors.outline,
      inverseSurface: AppColors.text,
      onInverseSurface: AppColors.background,
    );

    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: scheme,
      useMaterial3: true,
    );
    final text = base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    );
    TextStyle? display(TextStyle? s) =>
        s?.copyWith(fontFamily: displayFont, fontWeight: FontWeight.w700);

    const radius16 = BorderRadius.all(Radius.circular(16));
    const stadium = StadiumBorder();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: text.copyWith(
        displayLarge: display(text.displayLarge),
        displayMedium: display(text.displayMedium),
        displaySmall: display(text.displaySmall),
        headlineLarge: display(text.headlineLarge),
        headlineMedium: display(text.headlineMedium),
        headlineSmall: display(text.headlineSmall),
        titleLarge: display(text.titleLarge),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: displayFont,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: AppColors.text,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          side: BorderSide(color: AppColors.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: const OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide(color: AppColors.cyan, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide(color: AppColors.overdue),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide(color: AppColors.overdue, width: 1.5),
        ),
        labelStyle: const TextStyle(
          fontFamily: bodyFont,
          color: AppColors.textMuted,
        ),
        hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.6)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: stadium,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: stadium,
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.outline),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.cyan,
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.text),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.cyan,
        foregroundColor: Color(0xFF00161D),
        elevation: 0,
        highlightElevation: 0,
        shape: stadium,
        extendedTextStyle: TextStyle(
          fontFamily: bodyFont,
          fontWeight: FontWeight.w700,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceHigh,
        selectedColor: AppColors.cyan.withValues(alpha: 0.18),
        side: const BorderSide(color: AppColors.outline),
        shape: stadium,
        labelStyle: const TextStyle(
          fontFamily: bodyFont,
          color: AppColors.text,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: bodyFont,
          color: AppColors.cyan,
        ),
        iconTheme: const IconThemeData(color: AppColors.textMuted, size: 18),
        checkmarkColor: AppColors.cyan,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: AppColors.surface,
          selectedBackgroundColor: AppColors.cyan.withValues(alpha: 0.16),
          selectedForegroundColor: AppColors.cyan,
          foregroundColor: AppColors.textMuted,
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.text,
        unselectedLabelColor: AppColors.textMuted,
        dividerColor: AppColors.outline,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontFamily: bodyFont,
          fontWeight: FontWeight.w700,
        ),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.cyan, width: 3),
          borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        dragHandleColor: AppColors.outline,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radius16),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.surfaceHighest,
        contentTextStyle: TextStyle(
          fontFamily: bodyFont,
          color: AppColors.text,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radius16),
      ),
      listTileTheme: const ListTileThemeData(iconColor: AppColors.textMuted),
      dividerTheme: const DividerThemeData(color: AppColors.outline),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.cyan,
        linearTrackColor: AppColors.surfaceHigh,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? const Color(0xFF00161D)
              : AppColors.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.cyan
              : AppColors.surfaceHigh,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(AppColors.outline),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: const BorderSide(color: AppColors.textMuted, width: 1.5),
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.cyan
              : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(Color(0xFF00161D)),
      ),
    );
  }
}
