# Architecture Guardrails

This project is an opinionated Flutter application framework. The goal is to
make new features easy to add, review, test, and manipulate by giving every app
the same boring rails for data, state, routing, errors, and UI composition.

The working reference for every rule below is `lib/features/template/`. When
in doubt, copy its shape.

## Folder Shape

Use a feature-first structure for product code:

```text
lib/
  core/
    application/
    data/
    logging/
    l10n/
    result/
    routing/
    theme/
  shared/
    widgets/
  features/
    feature_name/
      application/
      domain/
      presentation/
```

- `core/` is for app-wide framework primitives that should not know about
  features.
- `core/application/` owns app-wide application-state helpers such as mutation
  runners and `Result` unwrap utilities.
- `core/data/` owns repository capability contracts and local storage helpers.
- `shared/widgets/` is the **single widget layer** — every reusable UI
  component lives here. Features do not have their own `widgets/` folder.
- `features/*/domain` owns business concepts and derived values.
- `features/*/application` owns Riverpod state, intent methods, and side-effect
  coordination.
- `features/*/presentation` owns pages, formatters, and presentation mappers.
  Pages compose `shared/widgets/` inline; there are no feature widget classes.

## Local Data Framework

Hive-backed repositories use `lib/core/data/` as their bread-and-butter local
storage base:

- Serialization is supplied as three inline functions — `id` (the entity's
  storage key), `toJson`, and `fromJson` — passed straight to `localRepository`
  or a `HiveLocalRepository` constructor. There is no separate codec class.
- `HiveLocalRepository<T>` provides list, watch, fetch, create, update,
  delete-by-id, and delete-by-predicate behavior.
- `localRepository<T>(...)` returns the `CrudRepository<T, String>` surface, so
  controllers depend on the interface and tests can fake it without a box.
- Repository interfaces stay feature-specific. A feature can still expose
  active selection, scoped reads, cascade deletes, or domain commands.
- Validation and business rules live in `LocalCrudNotifier` hooks
  (`beforeCreate` / `afterCreate` …); reach for a use case only when the same
  orchestration must be shared across two or more controllers.

### Do / Don't: Reuse Local Storage Mechanics

**Don't** — every repository hand-rolls the same Hive loop:

```dart
final items = box.values.map(decode).toList()
  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
yield* box.watch().asyncMap((_) => readAgain());
```

**Do (default)** — wire the whole repository in one line with `localRepository`.
No interface, no impl, no box registration, no `main()` setup; the box opens
lazily and `Hive.initFlutter()` runs once:

```dart
final projectRepositoryProvider = localRepository<Project>(
  box: 'projects',
  id: (project) => project.id,
  toJson: (project) => {'id': project.id, 'name': project.name},
  fromJson: (json) =>
      Project(id: json['id'] as String, name: json['name'] as String),
  sort: (a, b) => b.createdAt.compareTo(a.createdAt),
);
```

Pair it with `LocalCrudNotifier<Project>` on the controller and the feature has
no use-case files (see ADDING_FEATURE §0).

**Do (only when you need extra queries)** — subclass `HiveLocalRepository`:

```dart
class HiveProjectRepository extends HiveLocalRepository<Project>
    implements ProjectRepository {
  HiveProjectRepository({required Box<String> projectsBox})
    : super(
        box: projectsBox,
        id: (project) => project.id,
        toJson: (project) => {'id': project.id, 'name': project.name},
        fromJson: (json) =>
            Project(id: json['id'] as String, name: json['name'] as String),
        sort: (a, b) => b.createdAt.compareTo(a.createdAt),
      );

  @override
  Future<Result<List<Project>, Failure>> listProjects() => list();
}
```

`HiveLocalRepository` contract worth knowing:

- One-shot reads (`list`, `fetchById`) return `Result<T, Failure>`. Watch streams
  (`watch`, `watchAll`) stay `Stream<List<T>>` and surface failures as stream
  errors so Riverpod converts them to `AsyncError` — do not wrap stream payloads
  in `Result`.
- `create` is not an upsert: it returns `Err(ConflictFailure())` when the id
  already exists, mirroring how `update` returns `Err(NotFoundFailure())` when it
  does not. Generate a new id (or call `update`) instead of relying on overwrite.

## Dependency Direction

Dependencies should point toward stable concepts:

- Pages and widgets depend on application state and presentation helpers.
- Controllers depend on domain models, repositories, services, and core
  primitives.
- Repositories/services hide APIs, databases, SDKs, caches, and parsing.
- Domain models do not import Flutter widgets, colors, routing, or context.
- Feature-to-feature imports should be rare. Extract shared contracts into a
  neutral place when collaboration becomes real.

### Do / Don't: Keep Domain Flutter-Free

**Don't** — domain reaching into Flutter:

```dart
// lib/features/template/domain/project_track.dart
import 'package:flutter/material.dart';

enum ProjectTrack {
  active(Icons.bolt, Colors.green, 'Active'),
  archived(Icons.archive, Colors.grey, 'Archived');
  // ...
}
```

**Do** — pure domain, presentation owns the mapping:

```dart
// domain/project_track.dart — pure Dart, no Flutter import
enum ProjectTrack { active, archived }

// presentation/template_mappers.dart
IconData iconFor(ProjectTrack t) => switch (t) {
  ProjectTrack.active   => Icons.bolt,
  ProjectTrack.archived => Icons.archive,
};
```

## Page Responsibility

Pages own the whole screen. A page composes `shared/widgets/` inline, watches
state, holds ephemeral UI state, and dispatches user intent.

Do not put filtering, sorting, lookup helpers, parsing, formatting, validation,
business math, or enum icon/color/label mappings in a page file. Put those
responsibilities in domain models, controllers, formatter files, or mapper
files. *Layout*, however, belongs in the page — write the widget tree inline.

There is no page-size limit. A page that composes many shared widgets will be
long, and that is fine — do not break it into feature "section" widgets or
`_buildX()` helpers to shorten it. If a chunk of UI is reused across features,
promote it to a new `shared/widgets/` widget instead.

### Do / Don't: Page Holds Orchestration, Not Logic

**Don't** — filtering and math inlined in `build`:

```dart
final receipts = ref.watch(templateControllerProvider).valueOrNull ?? [];
final total = receipts
    .where((r) => r.confirmedAt != null)
    .fold<int>(0, (sum, r) => sum + r.total); // ← business math in build
return Text('\$$total');
```

**Do** — a pure helper owns the aggregate; the page just renders:

```dart
final receipts = ref.watch(templateControllerProvider).valueOrNull ?? [];
return Text(formatTemplateMoney(confirmedTotal(receipts)));
// confirmedTotal(...) is a pure function in domain;
// formatTemplateMoney lives in template_formatters.dart.
```

## One Widget Layer: Compose Shared Widgets Inline

**There is exactly one widget layer, `lib/shared/widgets/`. Pages compose it
inline. No feature widget classes, no `_buildX` methods, no private helpers.**

### Do / Don't: No `_buildSection()` Methods Returning `Widget`

**Don't** — a class pretending to be three widgets:

```dart
class _TemplateHomePageState extends ConsumerState<TemplateHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildHeader(),
      _buildReceiptList(),
      _buildTotalsFooter(),
    ]);
  }

  Widget _buildHeader() { /* 40 lines */ }
  Widget _buildReceiptList() { /* 80 lines */ }
  Widget _buildTotalsFooter() { /* 30 lines */ }
}
```

**Do** — write the tree inline from shared widgets. A long `build` is fine:

```dart
// presentation/template_home_page.dart
return AppSliverPage(
  title: context.l10n.appName,
  slivers: [
    SliverList.list(
      children: [
        AppSectionHeader(title: 'Receipts'),
        AppListSection(children: [for (final r in receipts) AppTile(...)]),
        AppCard(child: AppKeyValueRow(label: 'Total', value: total)),
      ],
    ),
  ],
);
```

### Do / Don't: No Feature Widget Classes

**Don't** — a feature "section" widget, whether private in the page file or in
its own `presentation/widgets/` file:

```dart
class _SectionCard extends StatelessWidget { ... }      // hidden in page
class TemplateReceiptList extends StatelessWidget { ... } // presentation/widgets/
```

**Do** — compose shared widgets inline. If the UI is genuinely reused across
features, add a **new shared widget** to `lib/shared/widgets/` and export it
from `widgets.dart`. There is no feature-local widget tier.

### Do / Don't: No Private `_format` / `_iconFor` / `_sort` Helpers

**Don't** — three different concerns hidden in a page file, none reusable,
none testable:

```dart
// presentation/template_home_page.dart
String _formatAmount(double v) => '\$${v.toStringAsFixed(2)}';
IconData _iconForTrack(ProjectTrack t) =>
    t == ProjectTrack.active ? Icons.bolt : Icons.archive;
List<ProjectReceipt> _sortByDate(List<ProjectReceipt> r) =>
    [...r]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
```

**Do** — each helper in its proper home:

```dart
// presentation/template_formatters.dart      — display strings
String formatAmount(double v) => '\$${v.toStringAsFixed(2)}';

// presentation/template_mappers.dart         — enum -> icon/color/label
IconData iconForTrack(ProjectTrack t) => switch (t) { ... };

// domain/project_receipt.dart                — derived value on the model
int get total => taxableSubtotal + tax;
```

### The Decision Flow

Before adding anything to a page, answer in order:

1. **String for display?** → `presentation/<feature>_formatters.dart`.
2. **Enum → icon / color / label?** → `presentation/<feature>_mappers.dart`.
3. **Filtering / sorting / math on domain data?** → getter on state, or a
   method on the domain model.
4. **A piece of UI?** → compose shared widgets inline. If the widget is
   missing, add it to `lib/shared/widgets/` and reuse it — never a feature
   widget class.
5. **Local UI state?** → make the page a `StatefulWidget` /
   `ConsumerStatefulWidget`. Business state stays in the controller.

## State And Data Flow

- Use Riverpod consistently for app state.
- Widgets send intent: `create`, `update`, `delete`, `refresh`.
- Controllers expose app state and intent-level methods.
- Repository providers are dependency wiring. Stream/Future providers expose
  read state. Notifiers/controllers own imperative user intent and transient
  mutation state.
- Business state lives outside widgets.
- Ephemeral UI state may stay in widgets when it is truly visual: focus,
  text controllers, hover, scroll position, tab selection.
- Avoid hidden writes in `build`; mutations should come from user actions,
  lifecycle hooks, or explicit effects.

### Do / Don't: Widgets Send Intent, Not Procedure

**Don't** — widget enforces a business rule, then mutates:

```dart
onPressed: () {
  if (draft.track == null) return; // business rule leaking into the page
  ref.read(templateControllerProvider.notifier).create(draft);
}
```

**Do** — widget names the intent; the rule lives in the controller's
`beforeCreate` hook and comes back as a `Result`:

```dart
onPressed: () async {
  final result =
      await ref.read(templateControllerProvider.notifier).create(draft);
  if (result case Err(failure: ValidationFailure(:final message))) {
    AppSnackBars.error(context, message);
  }
}
```

## Controllers, Stores, And Use Cases

The application layer has one default and two escape hatches. Start at the
default and only move outward when the rule below forces you to:

- **Default — the store.** `LocalCrudNotifier<T>` + `localRepository<T>` with
  business rules in hooks. This covers plain CRUD *and* multi-repository
  operations with rollback (see ADDING_FEATURE §0 and the hooks section of
  `local_crud_notifier.dart`).
- **Write-only controller — `MutationNotifier<T>`.** When there is no list to
  watch (a form posting to a remote API).
- **Use case — only for shared orchestration.** When the same multi-step logic
  must run from two or more controllers.

Use cases are for **orchestration**, not for wrapping every repository call:

- Use cases name the intent: `load`, `submit`, `confirm`, `watch`, `sync`.
- Use cases combine logic that needs to be reused across features; a single
  controller's multi-repository operation belongs in its hooks, not a use case.
- Use cases are exposed through small Riverpod providers in `application/`.
  Controllers read those providers instead of constructing use cases or reaching
  through a repository implementation directly.
- Don't create a one-line pass-through use case just to have one. If it only
  forwards a single repository call with no logic, use the store instead.

### Controller Base: Store Or MutationNotifier

**Plain CRUD + hooks → the store (default).** Mix `LocalCrudNotifier<T>` into the
controller, point `repository` at a `localRepository` provider, and return
`watchAll()` from `build()`. Create/update/delete/fetch come for free and return
`Result`. Business rules live in hooks — `beforeCreate` / `beforeUpdate` to
validate or normalise, `afterCreate` / `afterUpdate` / `afterDelete` to run side
effects or roll back a failed write. Hooks have access to `ref`, so
cross-repository reads and compensating writes belong here, not in a use case.

```dart
class TemplateController extends _$TemplateController
    with LocalCrudNotifier<ProjectReceipt> {
  @override
  CrudRepository<ProjectReceipt, String> get repository =>
      ref.read(templateRepositoryProvider);

  @override
  Stream<List<ProjectReceipt>> build() => watchAll();

  @override
  Future<Result<ProjectReceipt, Failure>> beforeCreate(ProjectReceipt draft) async {
    if (draft.track == null) {
      return const Err(ValidationFailure('Select a project track.'));
    }
    return Ok(ProjectReceipt.confirmed(track: draft.track, seats: draft.seats));
  }
}
```

**Write-only controllers → `MutationNotifier`.** A controller that does not back
a list — a form that submits to a remote API, say — has no `watchAll` stream.
Mix `MutationNotifier<T>` from `core/application/` onto an `AsyncNotifier<T>`
instead. Its `mutate` helper flips to loading while preserving the previous
value, folds the action's success value into state via `onSuccess`, keeps the
old value on error, logs failures through `loggerProvider`, and returns the
`Result` so the caller can still branch on it.

```dart
class SubmitFeedbackController extends _$SubmitFeedbackController
    with MutationNotifier<FeedbackState> {
  @override
  FeedbackState build() => const FeedbackState.empty();

  Future<void> submit(String message) => mutate(
    () => ref.read(submitFeedbackUseCaseProvider)(message),
    onSuccess: (_) => const FeedbackState.sent(),
    logMessage: 'Feedback submission failed',
  );
}
```

### Do / Don't: Validation Lives In Hooks, Not Scattered

**Don't** — re-checking the same rule in the widget and the repository:

```dart
// widget guards before calling, repository re-checks after — two homes, drift
if (draft.track == null) return;
// ...later, inside a fake/repo:
if (entity.track == null) return Err(ValidationFailure('...'));
```

**Do** — `beforeCreate` is the single home for the rule; it can read other
providers through `ref` and return an `Err` the page surfaces:

```dart
@override
Future<Result<ProjectReceipt, Failure>> beforeCreate(ProjectReceipt draft) async {
  if (draft.track == null) {
    return const Err(ValidationFailure('Select a project track.'));
  }
  return Ok(ProjectReceipt.confirmed(track: draft.track, seats: draft.seats));
}
```

### Do / Don't: Use A Use Case Only For Shared Orchestration

**Don't** — wrap a single repository call in a use case just to have a layer:

```dart
class LoadOrdersUseCase {
  const LoadOrdersUseCase(this._repository);
  final OrderRepository _repository;
  Future<Result<List<Order>, Failure>> call() => _repository.list(); // pass-through
}
```

**Do** — extract a use case only when the same multi-step logic runs from two or
more controllers. It takes repository *interfaces* (never concretions) and is
exposed through a provider:

```dart
class CheckoutUseCase {
  const CheckoutUseCase(this._orders, this._payments);
  final OrderRepository _orders;
  final PaymentRepository _payments;
  // multi-repo flow shared by, e.g., CartController and QuickBuyController
  Future<Result<Order, Failure>> call(Cart cart) async { /* ... */ }
}
```

A single controller's multi-repository operation belongs in its hooks
(`beforeCreate` + `afterCreate` rollback), not a use case.

### Streams Need No Use Case

For live data the controller's `build()` returns the repository stream directly
via `watchAll()`. Riverpod owns the subscription and converts each emission to
`AsyncValue<List<T>>` — no `StreamSubscription`, no `dispose`, no use case.

```dart
@override
Stream<List<Order>> build() => watchAll(); // from LocalCrudNotifier
```

## Routing

Keep routes centralized in `lib/core/routing`.

- Keep public route paths in `AppRoutes`.
- Pass primitive route parameters such as IDs and slugs.
- Avoid passing complex objects when a page should work from deep links,
  notifications, refreshes, or cold starts.
- Put auth/onboarding/entitlement redirects in router guards when those flows
  exist.

### Do / Don't: Primitive Route Params

**Don't** — passing an object that can't survive a deep link or cold start:

```dart
context.go('/receipt', extra: receipt);
```

**Do** — pass an ID; the destination watches a provider that loads the data:

```dart
context.go('${AppRoutes.receipt}/${receipt.id}');
```

## Failures, Logging, And Side Effects

- Repositories/services normalize SDK, network, database, parsing, and platform
  failures before they reach controllers.
- UI should display app-level failures, not raw SDK exceptions.
- Use `Result<T, Failure>` or the local async state convention at boundaries.
- Do not use `print` in app code. Use `loggerProvider`.
- Wrap analytics, crash reporting, permissions, storage, notifications, and
  platform SDKs behind services/providers.

### Do / Don't: Normalize Failures Before The UI

**Don't** — SDK exception leaking into UI state:

```dart
try {
  final res = await dio.get('/receipts');
  state = state.copyWith(receipts: parse(res.data));
} on DioException catch (e) {
  state = state.copyWith(errorMessage: e.message);
}
```

**Do** — repository returns `Result<T, Failure>`; controller maps it with a switch:

```dart
final result = await _repository.list();
state = switch (result) {
  Ok(value: final receipts) => AsyncData(receipts),
  Err(failure: final failure) => AsyncError(failure, StackTrace.current),
};
```

### Do / Don't: Logger, Not `print`

**Don't**

```dart
print('submit failed: $e');
```

**Do**

```dart
ref.read(loggerProvider).warn('submit failed', error: e, stackTrace: st);
```

## Localization And Accessibility

- User-facing strings should go through the app localization layer once they
  become product copy.
- Do not encode meaning through color alone.
- Preserve semantics labels, focus behavior, keyboard behavior, text scaling,
  and platform accessibility expectations.

## Testing

Mirror the app shape under `test/`.

- Domain: derived values, validation, mapping, and business rules.
- Application: state transitions, retries, and failure handling.
- Routing: guards and path construction when logic becomes nontrivial.
- Widgets: shared components and important flows with the real theme/providers.

Prefer focused tests around behavior that could realistically regress.

Logic buried in a page's `build` cannot be tested in isolation. If you want a
test for a piece of logic, it has to live in a domain file, a controller, a
formatter, a mapper, or a shared widget. That is another reason to keep pages
to pure composition and push logic down.

## Review Checklist

Use this before opening or approving a PR.

### Architecture

- Feature code lives under `lib/features/<feature>/`.
- `core/` stays app-wide and feature-free.
- `shared/widgets/` is the only widget layer; features have no `widgets/` folder.
- Imports follow the intended dependency direction.
- No new architecture package was added without a clear reason.

### Pages And Widgets

- Pages compose `shared/widgets/` inline, watch state, and dispatch intent.
- No page-size limit — a long, flat `build` is fine.
- New reusable UI is added to `lib/shared/widgets/`, not a feature widget.
- Formatting lives in formatter files.
- Enum labels, icons, and colors live in mapper files.
- Screens that depend on async state use `AppAsyncValueView<T>` instead of
  hand-rolling loading/error/data branches.
- Pages do not call APIs, databases, SDKs, repositories, use cases, or
  platform services.
- Text scales, truncates, or wraps without overflow.

### No Throwaway Private Code

- No `Widget _buildX()` methods anywhere — write the tree inline in `build`.
- No feature widget classes, whether private (`class _SectionCard extends
  StatelessWidget`) or in a feature file. Reusable UI is a shared widget.
- No private `_formatX` / `_iconFor` / `_sortBy` helpers in page files. They
  belong in `<feature>_formatters.dart`, `<feature>_mappers.dart`, the
  controller, or the domain model.

### State And Data

- Business state lives in controllers/notifiers/services, not widgets.
- Controllers expose intent-level methods.
- Controllers reach data via the store (`LocalCrudNotifier` + a `localRepository`
  provider) or a use case — never by importing a concrete repository
  implementation (`HiveFooRepository`).
- Business rules live in `LocalCrudNotifier` hooks (`beforeCreate` /
  `afterCreate` …); a use case appears only when the same orchestration is
  shared by two or more controllers.
- Use cases live under `application/use_cases/`, take repository interfaces, and
  are wired through Riverpod providers in `application/`.
- Write controllers use `MutationNotifier` when they only need
  loading/error/success mutation state.
- Repositories/services normalize low-level failures and return `Result<T, Failure>`.
- Hive-backed repositories reuse `HiveLocalRepository<T>` with inline
  `id` / `toJson` / `fromJson` functions instead of hand-rolling local
  list/watch/fetch/save/delete plumbing.
- Controllers unwrap `Result<T, Failure>` into `AsyncValue<T>` before the UI renders it.
- Derived values are getters or pure functions near the owning model/state.
- UI displays localized, user-facing messages.

### Routing, Logging, And Side Effects

- Route paths are centralized in `AppRoutes`.
- Navigation uses the app router instead of raw scattered strings.
- App code uses the logger abstraction instead of `print`.
- Platform SDKs and side effects are behind services/providers.
- Subscriptions, timers, controllers, and focus nodes have clear owners.

### Tests And Tooling

- Domain/controller behavior has focused tests.
- Use cases with behavior beyond simple forwarding have focused tests.
- Important shared widgets and flows have widget tests.
- Generated files were regenerated after annotation changes.
- `dart format .` has run.
- `flutter analyze` passes.
- `flutter test` passes.
