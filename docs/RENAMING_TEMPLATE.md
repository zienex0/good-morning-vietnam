# Renaming The Template

Use this checklist after creating a new app from Flutter Foundation Kit.

## 1. Rename Dart Package Metadata

Update `pubspec.yaml`:

- `name`
- `description`
- `version`, if the new app should not inherit the starter version

Then run:

```sh
flutter pub get
```

## 2. Rename User-Facing Brand Tokens

Start in `lib/core/theme/app_brand.dart`:

- `AppBrand.appName`
- `AppBrand.fontFamily`, if the app uses a different bundled font
- `AppColors`, if the app needs a different brand palette

Keep product-specific brand values here instead of scattering them through
widgets or theme component overrides.

## 3. Rename App Strings

Update `lib/core/l10n/app_localizations.dart` while the project uses the
lightweight string layer. If the app needs real localization, replace this file
with Flutter `gen-l10n` and ARB files before product copy grows.

## 4. Replace The Template Feature

`lib/features/template/` is a working architecture reference, not product code.
You can either:

1. keep it while building the first real feature and copy its shape, or
2. delete it after the first feature proves the pattern.

When deleting it, also remove:

- its route from `lib/core/routing/app_router.dart`
- template tests under `test/features/template/`
- any template-specific widget tests

## 5. Regenerate Files

Run:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Commit generated files together with the source files that produced them.

## 6. Run The Local Baseline

```sh
make check
```

If `make` is unavailable, run the commands from `README.md` manually.
