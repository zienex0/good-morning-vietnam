# Review Checklist

Use this before opening or approving a PR.

## Architecture

- Feature code lives under `lib/features/<feature>/`.
- `core/` stays app-wide and feature-free.
- `shared/widgets/` contains reusable UI, not feature-specific sections.
- Imports follow the intended dependency direction.
- No new architecture package was added without a clear reason.

## Pages And Widgets

- Pages compose widgets, watch state, and dispatch intent.
- Page files stay under 500 lines.
- Large sections live in feature widget files.
- Formatting lives in formatter files.
- Enum labels, icons, and colors live in mapper files.
- Screens that depend on async state use `AsyncValueView<T>` instead of
  hand-rolling loading/error/data branches.
- Widgets do not call APIs, databases, SDKs, repositories, use cases, or
  platform services.
- Text scales, truncates, or wraps without overflow.

## No Throwaway Private Code

- No `Widget _buildX()` methods anywhere. Section is a widget file, or it is
  inlined in `build`.
- No private widget classes (`class _SectionCard extends StatelessWidget`)
  declared inside a page or other consumer file. One widget per file, public
  name, under `presentation/widgets/` or `shared/widgets/`.
- No private `_formatX` / `_iconFor` / `_sortBy` helpers in page files. They
  belong in `<feature>_formatters.dart`, `<feature>_mappers.dart`, the
  controller, or the domain model.
- Anything used by a second feature has moved to `lib/shared/widgets/`.

## State And Data

- Business state lives in controllers/notifiers/services, not widgets.
- Controllers expose intent-level methods.
- Controllers depend on use cases for business operations, not directly on
  repositories when a feature has a data boundary.
- Use cases live under `application/use_cases/`, receive repositories, and keep
  operation names readable.
- Repositories/services normalize low-level failures and return
  `Result<T, Failure>`.
- Controllers unwrap `Result<T, Failure>` into `AsyncValue<T>` before the UI
  renders it.
- Derived values are getters or pure functions near the owning model/state.
- UI displays localized, user-facing messages.

## Routing, Logging, And Side Effects

- Route paths are centralized in `AppRoutes`.
- Navigation uses the app router instead of raw scattered strings.
- App code uses the logger abstraction instead of `print`.
- Platform SDKs and side effects are behind services/providers.
- Subscriptions, timers, controllers, and focus nodes have clear owners.

## Tests And Tooling

- Domain/controller behavior has focused tests.
- Use cases with behavior beyond simple forwarding have focused tests.
- Important shared widgets and flows have widget tests.
- Generated files were regenerated after annotation changes.
- `dart format .` has run.
- `flutter analyze` passes.
- `flutter test` passes.
