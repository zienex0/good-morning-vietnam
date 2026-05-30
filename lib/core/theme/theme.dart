import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/app_brand.dart';

export 'package:flutter_foundation_kit/core/theme/app_brand.dart';

const double _unit = 4;

abstract final class AppSpacing {
  static const double none = 0;
  static const double xs = _unit * 1;
  static const double sm = _unit * 2;
  static const double md = _unit * 4;
  static const double lg = _unit * 5;
  static const double xl = _unit * 8;
  static const double xxl = _unit * 12;
  static const double xxxl = _unit * 16;

  static const double page = lg;
  static const double pageWithinSectionGap = xl;
  static const double pageBetweenSectionGap = xxxl;
}

abstract final class AppSizes {
  static const double iconSm = _unit * 4;
  static const double iconMd = _unit * 5;
  static const double iconLg = _unit * 6;

  static const double controlSm = _unit * 8;
  static const double controlMd = _unit * 12;
  static const double buttonMinWidth = _unit * 24;

  static const double avatarSm = _unit * 8;
  static const double avatarMd = _unit * 12;
  static const double avatarLg = _unit * 18;

  static const double dropdownMenuMaxHeight = controlMd * 7;

  static const double chartHairline = _unit * 0.25;
  static const double chartStroke = _unit * 0.75;
  static const double chartDot = _unit;
  static const double chartBarHeight = _unit * 4;
  static const double chartBarWidth = _unit * 8;
  static const double chartBarChartHeight = _unit * 34;
  static const double chartRingStroke = _unit * 3;
  static const double chartRingSize = chartRingStroke * 10;
  static const double chartTrendHeight = _unit * 40;
  static const double chartLabelMinSpacing = _unit * 14;
}

abstract final class AppRadii {
  static const Radius md = Radius.circular(12);
  static const Radius lg = Radius.circular(16);
  static const Radius xl = Radius.circular(24);
  static const Radius pill = Radius.circular(999);
}

abstract final class AppDurations {
  static const Duration dropdownExpand = Duration(milliseconds: 220);
  static const Duration snackBarEntrance = Duration(milliseconds: 500);
  static const Duration snackBarExit = Duration(milliseconds: 350);
  static const Duration snackBarDisplay = Duration(seconds: 3);
  static const Duration chartEntrance = Duration(seconds: 2);
  static const Duration pageTransition = Duration(milliseconds: 300);
}

abstract final class AppCurves {
  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutBack;
}

abstract final class AppShadows {
  /// Subtle elevation for cards and grouped surfaces.
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: AppSpacing.md,
      offset: Offset(AppSpacing.none, AppSpacing.xs),
    ),
  ];
}

ThemeData buildAppTheme(AppPalette palette) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: palette.accent,
    brightness: palette.brightness,
    primary: palette.accent,
    onPrimary: palette.onAccent,
    surface: palette.surface,
    onSurface: palette.textPrimary,
  );

  final typography = Typography.material2021();
  final baseText =
      (palette.brightness == Brightness.dark
              ? typography.white
              : typography.black)
          .apply(
            bodyColor: palette.textPrimary,
            displayColor: palette.textPrimary,
            fontFamily: AppBrand.fontFamily,
          );

  return ThemeData(
    useMaterial3: true,
    brightness: palette.brightness,
    fontFamily: AppBrand.fontFamily,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.canvas,
    textTheme: baseText,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    extensions: [palette],
    appBarTheme: AppBarTheme(
      backgroundColor: palette.canvas,
      foregroundColor: palette.textPrimary,
      elevation: AppSpacing.none,
      centerTitle: false,
      surfaceTintColor: palette.canvas,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: AppSpacing.xxxl + AppSpacing.xl,
      backgroundColor: palette.sheet,
      surfaceTintColor: palette.sheet,
      elevation: AppSpacing.none,
      indicatorColor: palette.accent.withValues(alpha: 0.12),
      indicatorShape: const StadiumBorder(),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected ? palette.accent : palette.textMuted,
          size: AppSizes.iconLg,
        );
      }),
      labelTextStyle: WidgetStatePropertyAll(
        baseText.labelSmall?.copyWith(color: palette.textSecondary),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.textMuted.withValues(alpha: 0.48);
        }
        return states.contains(WidgetState.selected)
            ? palette.onAccent
            : palette.textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.surfaceStrong.withValues(alpha: 0.56);
        }
        return states.contains(WidgetState.selected)
            ? palette.accent
            : palette.surfaceStrong;
      }),
      trackOutlineColor: WidgetStatePropertyAll(palette.borderStrong),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.textMuted.withValues(alpha: 0.48);
        }
        return states.contains(WidgetState.selected)
            ? palette.accent
            : palette.textMuted;
      }),
    ),
    iconTheme: IconThemeData(
      color: palette.textSecondary,
      size: AppSizes.iconLg,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(palette.textPrimary),
        iconColor: WidgetStatePropertyAll(palette.textPrimary),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(AppSpacing.none)),
        fixedSize: const WidgetStatePropertyAll(
          Size.square(AppSizes.controlMd),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size.square(AppSizes.controlMd),
        ),
        maximumSize: const WidgetStatePropertyAll(
          Size.square(AppSizes.controlMd),
        ),
        shape: const WidgetStatePropertyAll(CircleBorder()),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: palette.surface,
      selectedColor: palette.accent,
      disabledColor: palette.surfaceRaised,
      showCheckmark: false,
      labelStyle: baseText.labelMedium?.copyWith(color: palette.textPrimary),
      secondaryLabelStyle: baseText.labelLarge?.copyWith(
        color: palette.onAccent,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadii.lg),
      ),
      side: BorderSide(color: palette.borderStrong),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: baseText.bodyMedium?.copyWith(color: palette.textPrimary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceRaised,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(AppRadii.lg),
          borderSide: BorderSide(color: palette.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(palette.sheet),
        surfaceTintColor: WidgetStatePropertyAll(palette.sheet),
        elevation: const WidgetStatePropertyAll(AppSpacing.none),
        maximumSize: const WidgetStatePropertyAll(
          Size.fromHeight(AppSizes.dropdownMenuMaxHeight),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(AppRadii.lg)),
        ),
        side: WidgetStatePropertyAll(BorderSide(color: palette.border)),
      ),
    ),
    cardTheme: CardThemeData(
      color: palette.surface,
      elevation: AppSpacing.none,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(AppRadii.lg),
        side: BorderSide(color: palette.border),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: palette.divider,
      thickness: 1,
      space: AppSpacing.xl,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return palette.surfaceStrong;
          }
          return palette.accent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return palette.textMuted;
          }
          return palette.onAccent;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        minimumSize: const WidgetStatePropertyAll(
          Size(AppSizes.buttonMinWidth, AppSizes.controlMd),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(AppRadii.lg)),
        ),
        textStyle: WidgetStatePropertyAll(baseText.labelLarge),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return palette.textMuted;
          }
          return palette.textPrimary;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        minimumSize: const WidgetStatePropertyAll(
          Size(AppSizes.buttonMinWidth, AppSizes.controlMd),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: palette.border);
          }
          return BorderSide(color: palette.borderStrong);
        }),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(AppRadii.lg)),
        ),
        textStyle: WidgetStatePropertyAll(baseText.labelLarge),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return palette.textMuted;
          }
          return palette.textPrimary;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(baseText.labelLarge),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(AppRadii.lg)),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: palette.inverseSurface,
      contentTextStyle: baseText.bodyMedium?.copyWith(
        color: palette.onInverseSurface,
      ),
      actionTextColor: palette.onInverseSurface,
      closeIconColor: palette.onInverseSurface,
      disabledActionTextColor: palette.onInverseSurface.withValues(alpha: 0.64),
      elevation: AppSpacing.none,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadii.lg),
      ),
      insetPadding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.none,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      showCloseIcon: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surfaceRaised,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintStyle: baseText.bodyMedium?.copyWith(color: palette.textMuted),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(AppRadii.lg),
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(AppRadii.lg),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(AppRadii.lg),
        borderSide: BorderSide(color: palette.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(AppRadii.lg),
        borderSide: BorderSide(color: palette.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(AppRadii.lg),
        borderSide: BorderSide(color: palette.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: palette.sheet,
      surfaceTintColor: palette.sheet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: AppRadii.xl),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: palette.sheet,
      surfaceTintColor: palette.sheet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadii.xl),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: palette.accent,
      circularTrackColor: palette.surfaceStrong,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: palette.accent,
      selectionColor: palette.accent.withValues(alpha: 0.18),
      selectionHandleColor: palette.accent,
    ),
  );
}

extension AppThemeContext on BuildContext {
  AppPalette get colors => Theme.of(this).extension<AppPalette>()!;

  TextTheme get text => Theme.of(this).textTheme;

  TextTheme get primaryText =>
      Theme.of(this).textTheme.apply(bodyColor: colors.textPrimary);

  TextTheme get secondaryText =>
      Theme.of(this).textTheme.apply(bodyColor: colors.textSecondary);

  TextTheme get mutedText =>
      Theme.of(this).textTheme.apply(bodyColor: colors.textMuted);

  TextTheme get inverseText =>
      Theme.of(this).textTheme.apply(bodyColor: colors.onInverseSurface);

  TextStyle? get headlineStrong =>
      text.headlineMedium?.copyWith(fontWeight: FontWeight.w800);

  TextStyle? get titleStrong =>
      text.titleLarge?.copyWith(fontWeight: FontWeight.w800);

  TextStyle? get labelStrong =>
      mutedText.labelLarge?.copyWith(fontWeight: FontWeight.w800);
}
