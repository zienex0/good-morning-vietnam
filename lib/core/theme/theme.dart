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
}

abstract final class AppCurves {
  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutBack;
}

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    primary: AppColors.accent,
    onPrimary: AppColors.onAccent,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
  );

  final baseText = Typography.material2021().black.apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
    fontFamily: AppBrand.fontFamily,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: AppBrand.fontFamily,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.canvas,
    textTheme: baseText,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.canvas,
      foregroundColor: AppColors.textPrimary,
      elevation: AppSpacing.none,
      centerTitle: false,
      surfaceTintColor: AppColors.canvas,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: AppSpacing.xxxl + AppSpacing.xl,
      backgroundColor: AppColors.sheet,
      surfaceTintColor: AppColors.sheet,
      elevation: AppSpacing.none,
      indicatorColor: AppColors.accent.withValues(alpha: 0.12),
      indicatorShape: const StadiumBorder(),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected ? AppColors.accent : AppColors.textMuted,
          size: AppSizes.iconLg,
        );
      }),
      labelTextStyle: WidgetStatePropertyAll(
        baseText.labelSmall?.copyWith(color: AppColors.textSecondary),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.textMuted.withValues(alpha: 0.48);
        }
        return states.contains(WidgetState.selected)
            ? AppColors.onAccent
            : AppColors.textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.surfaceStrong.withValues(alpha: 0.56);
        }
        return states.contains(WidgetState.selected)
            ? AppColors.accent
            : AppColors.surfaceStrong;
      }),
      trackOutlineColor: const WidgetStatePropertyAll(AppColors.borderStrong),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.textMuted.withValues(alpha: 0.48);
        }
        return states.contains(WidgetState.selected)
            ? AppColors.accent
            : AppColors.textMuted;
      }),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppSizes.iconLg,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
        iconColor: WidgetStatePropertyAll(AppColors.textPrimary),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStatePropertyAll(EdgeInsets.all(AppSpacing.none)),
        fixedSize: WidgetStatePropertyAll(Size.square(AppSizes.controlMd)),
        minimumSize: WidgetStatePropertyAll(Size.square(AppSizes.controlMd)),
        maximumSize: WidgetStatePropertyAll(Size.square(AppSizes.controlMd)),
        shape: WidgetStatePropertyAll(CircleBorder()),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.accent,
      disabledColor: AppColors.surfaceRaised,
      showCheckmark: false,
      labelStyle: baseText.labelMedium?.copyWith(color: AppColors.textPrimary),
      secondaryLabelStyle: baseText.labelLarge?.copyWith(
        color: AppColors.onAccent,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadii.pill),
      ),
      side: const BorderSide(color: AppColors.borderStrong),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: baseText.bodyMedium?.copyWith(color: AppColors.textPrimary),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceRaised,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(AppRadii.pill),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(AppRadii.pill),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(AppRadii.pill),
          borderSide: BorderSide(color: AppColors.borderStrong),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.sheet),
        surfaceTintColor: WidgetStatePropertyAll(AppColors.sheet),
        elevation: WidgetStatePropertyAll(AppSpacing.none),
        maximumSize: WidgetStatePropertyAll(
          Size.fromHeight(AppSizes.dropdownMenuMaxHeight),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(AppRadii.lg)),
        ),
        side: WidgetStatePropertyAll(BorderSide(color: AppColors.border)),
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: AppSpacing.none,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadii.lg),
        side: BorderSide(color: AppColors.border),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: AppSpacing.xl,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.surfaceStrong;
          }
          return AppColors.accent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textMuted;
          }
          return AppColors.onAccent;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        minimumSize: const WidgetStatePropertyAll(
          Size(AppSizes.buttonMinWidth, AppSizes.controlMd),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(AppRadii.pill)),
        ),
        textStyle: WidgetStatePropertyAll(baseText.labelLarge),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textMuted;
          }
          return AppColors.textPrimary;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        minimumSize: const WidgetStatePropertyAll(
          Size(AppSizes.buttonMinWidth, AppSizes.controlMd),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(color: AppColors.border);
          }
          return const BorderSide(color: AppColors.borderStrong);
        }),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(AppRadii.pill)),
        ),
        textStyle: WidgetStatePropertyAll(baseText.labelLarge),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textMuted;
          }
          return AppColors.textPrimary;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(baseText.labelLarge),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(AppRadii.pill)),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: baseText.bodyMedium?.copyWith(
        color: AppColors.onAccent,
      ),
      actionTextColor: AppColors.onAccent,
      closeIconColor: AppColors.onAccent,
      disabledActionTextColor: AppColors.onAccent.withValues(alpha: 0.64),
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
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceRaised,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(AppRadii.pill),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(AppRadii.pill),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(AppRadii.pill),
        borderSide: BorderSide(color: AppColors.borderStrong),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.sheet,
      surfaceTintColor: AppColors.sheet,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: AppRadii.xl),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.sheet,
      surfaceTintColor: AppColors.sheet,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadii.xl),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accent,
      circularTrackColor: AppColors.surfaceStrong,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.accent,
      selectionColor: AppColors.accent.withValues(alpha: 0.18),
      selectionHandleColor: AppColors.accent,
    ),
  );
}

extension AppThemeContext on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;

  TextTheme get primaryText =>
      Theme.of(this).textTheme.apply(bodyColor: AppColors.textPrimary);

  TextTheme get secondaryText =>
      Theme.of(this).textTheme.apply(bodyColor: AppColors.textSecondary);

  TextTheme get mutedText =>
      Theme.of(this).textTheme.apply(bodyColor: AppColors.textMuted);

  TextTheme get inverseText =>
      Theme.of(this).textTheme.apply(bodyColor: AppColors.onAccent);

  TextStyle? get headlineStrong =>
      text.headlineMedium?.copyWith(fontWeight: FontWeight.w800);

  TextStyle? get titleStrong =>
      text.titleLarge?.copyWith(fontWeight: FontWeight.w800);

  TextStyle? get labelStrong =>
      mutedText.labelLarge?.copyWith(fontWeight: FontWeight.w800);
}
