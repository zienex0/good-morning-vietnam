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

- `feature_name_repository.dart` (one per aggregate when the feature grows)
- `feature_name_providers.dart` (the single home for the feature's providers)
- `create_feature_name_use_case.dart` / `calculate_feature_name_use_case.dart`
- `feature_name_formatters.dart`
- `feature_name_mappers.dart`
- `feature_name_page.dart`

## 2. Put Responsibilities In The Right Place

- Put business concepts, enums, and derived values in `domain/`. No providers.
- Put repository contracts, fake implementations, DTO mapping, SDK calls, API
  calls, parsing, cache access, and local persistence in `data/`. Repositories
  expose reactive `watch*` streams plus CRUD. No providers in `data/`.
- Put the feature's providers in `application/`, split into small per-concern
  files (e.g. `trips_provider.dart`, `active_trip_provider.dart`,
  `trip_account_form_provider.dart`) — the DI/repository providers, the reactive
  data providers, derived-value providers, and one write notifier per aggregate.
  Prefer many small per-aggregate features over one big one. A feature owns its
  model and may import another feature's model/providers when it needs them.
- Put feature-specific use cases in `application/use_cases/` as plain classes —
  validation, cross-repository orchestration, or derived calculations only.
  Never give a use case its own provider, and never write a use case that only
  forwards one repository call. Reads with no logic come straight from a data
  provider over the repository stream.
- Put pages, formatter functions, mapper functions, and feature-only widgets in
  `presentation/`.
- Move a widget to `shared/widgets/` only after a second feature needs it.
- Add app-wide primitives to `core/` only when they are stable and feature-free.

## 3. Keep Data Flow Explicit

- Repositories return `Result<T, Failure>` and expose `watch*` streams.
- Data providers return repository streams; reads need no use case.
- Use cases (plain classes) hold validation / orchestration / calculation and
  return `Result<T, Failure>`.
- A view provider assembles a screen's data into a plain record (no summary
  class), throwing failures so the page can render `AsyncValue<T>`.
- Notifiers unwrap `Result<T, Failure>` into `AsyncValue<T>` for their own
  loading/error; writes re-emit through the streams, so no manual invalidation.
- Pages render `AsyncValue<T>` through `AppAsyncValueView<T>` when the whole
  screen depends on async state.
- Widgets watch providers and send intent to notifiers. They do not call
  repositories, APIs, databases, SDKs, or platform services directly.

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
