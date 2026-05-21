# Adding A Feature

Use this checklist when creating a new feature. Start small, then split only
when complexity makes the boundary useful.

## 1. Create The Feature Folder

```text
lib/features/feature_name/
  data/
  application/
    use_cases/
  domain/
  presentation/
    widgets/
```

Use package imports. Keep names boring and searchable:

- `feature_name_repository.dart`
- `load_feature_name_use_case.dart`
- `submit_feature_name_use_case.dart`
- `feature_name_controller.dart`
- `feature_name_state.dart`
- `feature_name_formatters.dart`
- `feature_name_mappers.dart`
- `feature_name_page.dart`

## 2. Put Responsibilities In The Right Place

- Put business concepts, enums, and derived values in `domain/`.
- Put repository contracts, fake implementations, DTO mapping, SDK calls, API
  calls, parsing, cache access, and local persistence in `data/`.
- Put Riverpod controllers/state and intent methods in `application/`.
- Put feature-specific use cases in `application/use_cases/`; use cases receive
  repositories and expose action names such as `load`, `submit`, `confirm`, or
  `sync`. Controllers never import repositories directly — always go through a
  use case. Business validation (preconditions, cross-field rules) belongs in
  the use case, not the controller or the repository.
- Put pages, formatter functions, mapper functions, and feature-only widgets in
  `presentation/`.
- Move a widget to `shared/widgets/` only after a second feature needs it.
- Add app-wide primitives to `core/` only when they are stable and feature-free.

## 3. Keep Data Flow Explicit

- Repositories return `Result<T, Failure>`.
- Use cases call repositories and keep operation names readable.
- Controllers unwrap `Result<T, Failure>` into `AsyncValue<T>`.
- Pages render `AsyncValue<T>` through `AsyncValueView<T>` when the whole screen
  depends on async state.
- Widgets send intent methods to controllers. They do not call repositories,
  use cases, APIs, databases, SDKs, or platform services directly.

## 4. Wire Routing

- Add or update the path in `AppRoutes`.
- Add the route in `appRouterProvider`.
- Import the feature page from its presentation path.
- Pass IDs/slugs through routes; load data through controller/use case state.

## 5. Add Tests

Mirror the feature under `test/features/feature_name/`.

- Test domain derived values and edge cases.
- Test use cases around repository success and failure paths when they contain
  behavior beyond simple forwarding.
- Test controller state transitions and bounds.
- Add a widget test for important UI flows.
- Use fakes for simple dependencies and mocks for interaction-heavy boundaries.

## 6. Run The Baseline

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
