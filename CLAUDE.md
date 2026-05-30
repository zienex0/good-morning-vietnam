# Agent Instructions

This file is the entrypoint for AI coding agents (Claude Code, Codex, Cursor,
Copilot) working in this repository. Read it first. Then follow
`docs/ARCHITECTURE.md` (which ends with the review checklist) and
`docs/ADDING_FEATURE.md`.

The working reference for every framework pattern is `lib/features/template/`.
Copy its shape before inventing a new one.

## The Two Rules You Will Most Often Break

### 1. Pages compose shared widgets inline — no feature widget classes

**There is exactly one widget layer: `lib/shared/widgets/`.** A page builds its
whole UI by composing those widgets directly in `build`. Do not split a page
into feature "section" widgets (`MyOverviewSection`, `MyHeaderCard`), do not
create a `presentation/widgets/` folder, and do not add `_buildHeader()` methods
or private `_SectionCard` classes. Write the tree inline — a long `build` is
fine (there is no line limit).

If a piece of UI is genuinely reused across features, promote it to a **new
shared widget** in `lib/shared/widgets/` and export it from `widgets.dart` — not
to a feature-local widget. One layer, no in-between.

If you find yourself typing `Widget _build` or creating a `class _Something
extends StatelessWidget`, stop. That is the smell.

### 2. Controllers reach data in exactly one of two ways

A controller never hand-rolls repository calls or business logic inline in its
methods. It reaches data through one of two sanctioned paths:

- **Plain CRUD + hooks → the store.** Define the data layer in one line with
  `localRepository<T>(...)` (no interface, no impl, no `main()` wiring), then mix
  `LocalCrudNotifier<T>` into the controller and expose the provider. You get
  `watchAll` / `create` / `update` / `delete` for free, returning `Result`.
  Business rules go in hooks — `beforeCreate` / `beforeUpdate` to validate or
  normalise, `afterCreate` / `afterUpdate` / `afterDelete` to run side effects or
  roll back a write that failed. Hooks have access to `ref`, so cross-repository
  reads and compensating writes are fine here. No use case file needed.
- **Shared orchestration → a use case.** Only reach for a use case when the same
  multi-step logic must run from two or more controllers. A single controller's
  multi-repository operation belongs in its hooks.

The smell to avoid is unchanged: a controller importing a concrete repository
*implementation* (`HiveFooRepository`) or embedding multi-step logic in a
method. Depending on a `localRepository` *provider* via the store is fine.

## Decision Flow Before Writing Anything In A Page

Before adding anything to a page, answer in order:

1. **String for display?** → `presentation/<feature>_formatters.dart`.
2. **Enum → icon / color / label?** → `presentation/<feature>_mappers.dart`.
3. **Filtering / sorting / math on domain data?** → a getter on state, or a
   method on the domain model.
4. **A piece of UI?** → compose shared widgets from `lib/shared/widgets/`
   inline in the page's `build`. If the widget you need does not exist, add it
   to `lib/shared/widgets/` and reuse it — never a feature widget class.
5. **Local UI state (selection, toggles)?** → make the page a
   `StatefulWidget` / `ConsumerStatefulWidget`. Business state stays in the
   controller.

## Stop And Ask The User Before

- Adding a new package to `pubspec.yaml` unless the user explicitly asks for a
  framework-level primitive that needs it.
- Removing or downgrading a dependency.
- Adding a new folder under `lib/core/` or a new top-level folder under `lib/`.
- Changing an existing public route path in `AppRoutes`.
- Introducing a second state-management library alongside Riverpod.
- Generating files outside the feature you were asked to touch.
- Disabling an analyzer rule in `analysis_options.yaml`.

## Baseline Commands

Run the full baseline before handing off a change — the commands live in
`README.md` › **Baseline Commands** (`flutter pub get`, `build_runner`,
`dart format .`, `flutter analyze`, `flutter test`), or just `make check`.

If any step fails, fix the cause. Do not skip steps, do not pass `--no-verify`,
do not silence lints to make the diff pass.

## Shared Widget Catalog

**Before you build any UI, check this list. If a widget here fits, use it — do
not hand-roll your own.** Import the whole kit with one line:

```dart
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
```

These widgets are intentionally opinionated. They take *content* (titles, data,
callbacks) and bake in *all* styling from the theme. There are no `padding`,
`borderRadius`, `color`, or `style` knobs — if you need a different look, that is
a theme/token change (`lib/core/theme/`) or a new named widget, never a new
parameter. Keep them that way.

Read colors via `context.colors` (an `AppPalette` that flips between light and
dark) and spacing/sizes via `AppSpacing` / `AppSizes` — never hardcode a
`Color(...)` or a magic number. Theme mode is driven by `themeModeProvider`.

| Widget | Use it for |
| --- | --- |
| `AppSliverPage` | The page scaffold: collapsing title/subtitle, leading, actions, slivers, bottom bar. Every screen starts here. |
| `AppAsyncValueView<T>` | Render a Riverpod `AsyncValue<T>` — loading / error / retry / data — instead of hand-rolling branches. |
| `AppCard` | The rounded surface primitive with soft elevation. Use it instead of a hand-rolled `Container` decoration. Optional `onTap`. |
| `AppButton` | `AppButton.primary/.secondary/.text/.danger(...)` with built-in `loading` spinner, optional `icon`, and `expanded` for full width. Use instead of raw `FilledButton`/`OutlinedButton`. |
| `AppListSection` + `AppTile` | iOS grouped list: `AppListSection(header:, children: [AppTile(...)])`. `AppTile` is the row (leading / title / subtitle / trailing, auto chevron when tappable). |
| `AppBottomActionBar` | The pinned bottom bar surface that wraps a primary action (pass a `child`). |
| `AppSnackBars` | `AppSnackBars.success/.error/.info(context, msg)` transient toasts — never call `ScaffoldMessenger` directly. |
| `AppDialog` | `AppDialog.confirm(context, …) → Future<bool>` and `AppDialog.alert(...)`. Use instead of `showDialog`. |
| `AppBottomSheet` / `AppActionSheet` | `AppBottomSheet.show(context, child:)` for custom sheets; `AppActionSheet.show(context, actions: [AppAction(...)])` for an iOS action list. Use instead of `showModalBottomSheet`. |
| `AppBanner` | Persistent inline message strip (`info`/`success`/`warning`/`error`), optional `onClose`. Use for status that should stay on screen. |
| `AppLoadingOverlay` | A blocking scrim + spinner; drop as the last child of a `Stack` while a blocking op runs. |
| `AppSkeleton` | Animated shimmer placeholder; compose several to mimic the loading layout. |
| `AppEmptyState` | Empty/zero-data screens: icon + title + description + optional action. |
| `AppSectionHeader` | Section heading: optional eyebrow, title, body, trailing. |
| `AppKeyValueRow` | A label/value line; pass `emphasized: true` for a total/summary row. |
| `AppDropdown<T>` | Themed dropdown built from `AppDropdownOption<T>`s. |
| `AppCounterStepper` | Label + decrement/value/increment stepper. |
| `AppBackButton` | The standard back button (`context.pop`). |
| `AppShell` | Bottom-nav shell for `StatefulNavigationShell` branches. |
| `AppDonutChart` / `AppRoundedBarChart` | Categorical charts. Feed `List<AppChartDatum>` (label + value; `detail`/`color` optional, colors auto-assigned). |
| `AppTrendChart` | Time-series line chart. Feed `List<AppTrendPoint>` (date + value). |
| `app_formatters.dart` | `formatCurrency`, `formatCents`, `formatShortDate`, `formatPercent`, etc. Format here, not inline. |

If a genuinely reusable widget is missing, add it to `lib/shared/widgets/` and
export it from `widgets.dart` — do not inline a one-off in a page.

## Where To Look

- `docs/ARCHITECTURE.md` — folder shape, dependency direction, do/don't
  examples, and the review checklist to run before a PR.
- `docs/ADDING_FEATURE.md` — checklist for adding a new feature.
- `lib/features/template/` — working reference feature (state, async, navigation).
- `lib/features/gallery/` — live showcase of every shared widget.
- `lib/core/application/` — framework helpers for mutation state and result
  unwrapping.
- `lib/core/data/` — local data framework primitives for Hive-backed
  repositories.
- `lib/core/routing/app_router.dart` — tab shell + pushed detail route with a
  slide transition (navigation reference).
