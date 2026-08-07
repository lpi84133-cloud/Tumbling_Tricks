import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'metrics.dart';
import 'palette.dart';
import 'typography.dart';

/// The single theme for the app.
///
/// There is no light variant: the artwork is painted for a darkened house, and
/// a light rendering of it would look broken. The one place that is
/// deliberately light-on-dark inverted is the Privacy / Support reader, which
/// renders black text on white paper for legibility.
abstract final class AppTheme {
  static ThemeData build() {
    const ColorScheme scheme = ColorScheme.dark(
      primary: Palette.brass,
      onPrimary: Palette.ink,
      primaryContainer: Palette.bordeaux,
      onPrimaryContainer: Palette.textPrimary,
      secondary: Palette.emeraldGlow,
      onSecondary: Palette.ink,
      secondaryContainer: Palette.emerald,
      onSecondaryContainer: Palette.textPrimary,
      tertiary: Palette.paper,
      onTertiary: Palette.textOnPaper,
      surface: Palette.ink,
      onSurface: Palette.textPrimary,
      surfaceContainerLowest: Palette.ink,
      surfaceContainerLow: Palette.inkRaised,
      surfaceContainer: Palette.inkPanel,
      surfaceContainerHigh: Palette.bordeauxDeep,
      surfaceContainerHighest: Palette.bordeaux,
      onSurfaceVariant: Palette.textSecondary,
      outline: Palette.hairlineStrong,
      outlineVariant: Palette.hairline,
      error: Palette.danger,
      onError: Palette.textPrimary,
      errorContainer: Palette.dangerSoft,
      onErrorContainer: Palette.textPrimary,
      inverseSurface: Palette.paper,
      onInverseSurface: Palette.textOnPaper,
    );

    final TextTheme textTheme = TextTheme(
      displayLarge: AppText.display,
      displayMedium: AppText.display,
      displaySmall: AppText.screenTitle,
      headlineLarge: AppText.screenTitle,
      headlineMedium: AppText.screenTitle,
      headlineSmall: AppText.cardTitle,
      titleLarge: AppText.cardTitle,
      titleMedium: AppText.bodyStrong,
      titleSmall: AppText.sectionLabel,
      bodyLarge: AppText.body,
      bodyMedium: AppText.body,
      bodySmall: AppText.caption,
      labelLarge: AppText.action,
      labelMedium: AppText.caption,
      labelSmall: AppText.micro,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Palette.ink,
      canvasColor: Palette.ink,
      textTheme: textTheme,
      fontFamily: Fonts.body,
      splashFactory: InkSparkle.splashFactory,
      highlightColor: Palette.brass.withValues(alpha: 0.06),
      splashColor: Palette.brass.withValues(alpha: 0.10),
      dividerTheme: const DividerThemeData(
        color: Palette.hairline,
        thickness: 1,
        space: Gap.lg,
      ),
      // The app uses its own header and Arena Dock, so the Material AppBar
      // only ever appears inside modal routes.
      appBarTheme: AppBarTheme(
        backgroundColor: Palette.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.cardTitle,
        iconTheme: const IconThemeData(color: Palette.brass, size: 22),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      iconTheme: const IconThemeData(color: Palette.brass, size: 22),
      cardTheme: const CardThemeData(
        color: Palette.inkPanel,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Corners.card,
          side: BorderSide(color: Palette.hairline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Palette.bordeaux,
          foregroundColor: Palette.brassGlow,
          disabledBackgroundColor: Palette.inkPanel,
          disabledForegroundColor: Palette.textDisabled,
          minimumSize: const Size(0, Layout.minTouch + 6),
          padding: const EdgeInsets.symmetric(horizontal: Gap.xl),
          textStyle: AppText.action,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.chip,
            side: BorderSide(color: Palette.brassDim),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Palette.brass,
          minimumSize: const Size(0, Layout.minTouch + 6),
          padding: const EdgeInsets.symmetric(horizontal: Gap.xl),
          textStyle: AppText.action,
          side: const BorderSide(color: Palette.hairlineStrong),
          shape: const RoundedRectangleBorder(borderRadius: Corners.chip),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Palette.brass,
          textStyle: AppText.action,
          minimumSize: const Size(0, Layout.minTouch),
          padding: const EdgeInsets.symmetric(horizontal: Gap.md),
          shape: const RoundedRectangleBorder(borderRadius: Corners.chip),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Palette.inkRaised,
        hintStyle: AppText.body.copyWith(color: Palette.textTertiary),
        labelStyle: AppText.caption,
        floatingLabelStyle: AppText.sectionLabel,
        helperStyle: AppText.micro,
        errorStyle: AppText.micro.copyWith(color: Palette.danger),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Gap.lg,
          vertical: Gap.md + 2,
        ),
        border: const OutlineInputBorder(
          borderRadius: Corners.chip,
          borderSide: BorderSide(color: Palette.hairline),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: Corners.chip,
          borderSide: BorderSide(color: Palette.hairline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: Corners.chip,
          borderSide: BorderSide(color: Palette.brass, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: Corners.chip,
          borderSide: BorderSide(color: Palette.danger),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: Corners.chip,
          borderSide: BorderSide(color: Palette.danger, width: 1.5),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? Palette.brassGlow
              : Palette.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? Palette.emerald
              : Palette.inkPanel;
        }),
        trackOutlineColor: const WidgetStatePropertyAll<Color>(Palette.hairline),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? Palette.emeraldLift
              : Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll<Color>(Palette.brassGlow),
        side: const BorderSide(color: Palette.brassDim, width: 1.4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: Palette.brass,
        inactiveTrackColor: Palette.inkPanel,
        thumbColor: Palette.brassGlow,
        overlayColor: Color(0x22C9A84C),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Palette.brass,
        linearTrackColor: Palette.inkPanel,
        circularTrackColor: Palette.inkPanel,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Palette.inkRaised,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: Palette.scrim,
        shape: RoundedRectangleBorder(borderRadius: Corners.sheet),
        showDragHandle: true,
        dragHandleColor: Palette.brassDim,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Palette.inkPanel,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppText.cardTitle,
        contentTextStyle: AppText.body,
        shape: const RoundedRectangleBorder(
          borderRadius: Corners.panel,
          side: BorderSide(color: Palette.hairlineStrong),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Palette.bordeaux,
        contentTextStyle: AppText.bodyStrong,
        actionTextColor: Palette.brassGlow,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: Corners.chip,
          side: BorderSide(color: Palette.brassDim),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(
          color: Palette.inkPanel,
          borderRadius: Corners.chip,
          border: Border.fromBorderSide(BorderSide(color: Palette.hairline)),
        ),
        textStyle: AppText.micro.copyWith(color: Palette.textPrimary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Palette.inkRaised,
        selectedColor: Palette.bordeaux,
        labelStyle: AppText.caption.copyWith(color: Palette.textPrimary),
        side: const BorderSide(color: Palette.hairline),
        shape: const RoundedRectangleBorder(borderRadius: Corners.pill),
        padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: Gap.xs),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Palette.brass,
        titleTextStyle: null,
        minVerticalPadding: Gap.md,
        contentPadding: EdgeInsets.symmetric(horizontal: Gap.lg),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Status bar / home indicator styling for the dark stage chrome.
  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Palette.ink,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}
