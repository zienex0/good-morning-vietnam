# Flutter Foundation Framework

An opinionated source-first Flutter framework for teams. It gives new apps
predictable architecture rails, shared UI primitives, local data storage
helpers, strict analyzer defaults, async data flow, and short guardrail docs
that make feature work feel like bread and butter.

## What's Included

- `lib/core`: app-wide routing, theme, brand tokens, logging, result/failure
  primitives, application-state helpers, local data framework pieces, and
  localization helpers.
- `lib/shared/widgets`: reusable page, chart, form, async, empty-state, and
  layout widgets.
- `lib/features/template`: a small working feature that demonstrates the
  expected data, domain, controller, presentation, formatter, and mapper split
  using `LocalCrudNotifier` + hooks.
- `docs`: architecture rules (ending with the review checklist) and
  feature-addition steps.
- `test`: baseline tests for app boot, shared widgets, and the template
  feature's domain/controller behavior.
- `Makefile`: local shortcuts for generation, formatting, analysis, tests, and
  the full baseline check.

## Reference Flow

Framework features use a boring, repeatable path:

```text
localRepository<T> -> LocalCrudNotifier (+ hooks) -> Controller -> AsyncValue<List<T>> -> AppAsyncValueView<T> -> Widgets
```

Most features are plain CRUD over local storage: declare the repository in one
line with `localRepository<T>`, mix `LocalCrudNotifier<T>` into the controller,
return `watchAll()` from `build()`, and put business rules in `beforeCreate` /
`afterCreate` hooks. Repositories return `Result<T, Failure>`; controllers expose the
live list plus intent methods; pages render full-screen async state through
`AppAsyncValueView<T>` instead of hand-rolling loading/error/data branches.
Reach for a use case only when the same orchestration must run from two or more
controllers, and use `MutationNotifier<T>` for a write-only controller that has
no list to watch.

## Local Data Framework

Hive-backed feature repositories reuse `HiveLocalRepository<T>` with inline
`id` / `toJson` / `fromJson` functions instead of rewriting
list/watch/fetch/create/update/delete plumbing. For plain CRUD,
`localRepository<T>` wires the whole thing in one declaration and exposes the
`CrudRepository<T, String>` surface; subclass `HiveLocalRepository<T>` only when
a feature needs custom queries, cascades, active selections, or domain commands.

## Start A New App

Use this repository as the source framework, then generate only the platform
folders the app needs:

```sh
flutter create . --platforms=android,ios,web,macos,windows,linux
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
```

Remove any platform from the `--platforms` list when it is not needed.

Then work through **Renaming The Template** below to rename package metadata,
brand tokens, strings, and the starter feature.

## Renaming The Template

After creating a new app from the kit, work through these once:

### 1. Rename Dart package metadata

Update `pubspec.yaml` — `name`, `description`, and `version` (if the new app
should not inherit the starter version) — then run `flutter pub get`.

### 2. Rename user-facing brand tokens

Start in `lib/core/theme/app_brand.dart`: `AppBrand.appName`,
`AppBrand.fontFamily` (if the app uses a different bundled font), and
`AppColors` (if the app needs a different brand palette). Keep product-specific
brand values here instead of scattering them through widgets or theme overrides.

### 3. Rename app strings

Update `lib/core/l10n/app_localizations.dart` while the project uses the
lightweight string layer. If the app needs real localization, replace it with
Flutter `gen-l10n` and ARB files before product copy grows.

### 4. Replace the template feature

`lib/features/template/` is a working architecture reference, not product code.
Keep it while building the first real feature and copy its shape, or delete it
once the first feature proves the pattern. When deleting it, also remove its
route from `lib/core/routing/app_router.dart` and its tests under
`test/features/template/`.

### 5. Regenerate and verify

Run `dart run build_runner build --delete-conflicting-outputs`, commit generated
files alongside the source that produced them, then run the baseline below.

## Guardrails

- AI coding agents: start at `CLAUDE.md`.
- Read `docs/ARCHITECTURE.md` before changing structure, state, routing,
  errors, logging, localization, or test shape.
- Follow `docs/ADDING_FEATURE.md` when adding a new feature.
- Work through **Renaming The Template** (above) when creating a real app.
- Use the **Review Checklist** at the end of `docs/ARCHITECTURE.md` before
  opening a PR.
- Keep `core/` app-wide and stable. Keep `shared/` UI-only and reusable.
- Pages compose `lib/shared/widgets/` inline — that is the only widget layer.
  No feature widget classes, no `Widget _buildX()` methods, no private widget
  classes or helpers. If a UI piece is missing, add it to `lib/shared/widgets/`.

## Baseline Commands

Run the full local baseline before handing off a change:

```sh
make check
```

Or run the same steps manually:

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
```
