# Architecture Guardrails

This kit is intentionally small, but it is not patternless. The goal is to make
new features easy to review, test, and move without turning the starter into a
framework.

The working reference for every rule below is `lib/features/template/`. When
in doubt, copy its shape.

## Folder Shape

Use a feature-first structure for product code:

```text
lib/
  core/
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
        widgets/
```

- `core/` is for app-wide primitives that should not know about features.
- `shared/widgets/` is for reusable UI components, not feature-specific
  sections.
- `features/*/domain` owns business concepts and derived values.
- `features/*/application` owns Riverpod state, intent methods, and side-effect
  coordination.
- `features/*/presentation` owns pages, formatters, presentation mappers, and
  feature widgets.

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

Pages are orchestration only. A page may compose widgets, watch state, own
ephemeral UI controllers, and dispatch user intent.

Do not put filtering, sorting, lookup helpers, parsing, formatting, validation,
business math, enum icon/color/label mappings, or large section widgets in a
page file. Put those responsibilities in domain models, controllers, formatter
files, mapper files, or extracted widgets.

Keep page files under 500 lines. Treat a page approaching that size as a prompt
to extract sections before adding more behavior.

### Do / Don't: Page Holds Orchestration, Not Logic

**Don't** — sorting, filtering, and math inlined in `build`:

```dart
class TemplateHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipts = ref.watch(templateControllerProvider).receipts;
    final visible = receipts
        .where((r) => r.track == ProjectTrack.active)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final total = visible.fold<double>(0, (s, r) => s + r.amount);
    return Text('Total: \$${total.toStringAsFixed(2)}');
  }
}
```

**Do** — state exposes the derived value, formatter renders the string:

```dart
class TemplateHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templateControllerProvider);
    return Text(formatCurrency(state.activeTotal));
  }
}
// Sorting + summing live on the state or a domain getter.
// formatCurrency lives in template_formatters.dart.
```

## Reusable Code: No `_buildX`, No Private Widgets, No Private Helpers

**If it's worth naming, it's worth a file. If it isn't worth a file, inline it.**

Three concrete forms this rule takes:

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

These can't be `const`, can't be tested in isolation, can't be reused, and
balloon the page file.

**Do** — one widget per file under `presentation/widgets/`:

```dart
// presentation/widgets/template_header.dart
class TemplateHeader extends StatelessWidget { ... }

// presentation/widgets/template_receipt_list.dart
class TemplateReceiptList extends ConsumerWidget { ... }

// presentation/template_home_page.dart
Column(children: const [
  TemplateHeader(),
  TemplateReceiptList(),
  TemplateTotalsFooter(),
])
```

### Do / Don't: No Private Widget Classes Inside Page Files

**Don't** — invisible to every other file, impossible to reuse without
copy-paste:

```dart
// presentation/template_home_page.dart
class TemplateHomePage extends ConsumerWidget { ... }

class _SectionCard extends StatelessWidget { ... }
class _ReceiptTile  extends StatelessWidget { ... }
class _EmptyState   extends StatelessWidget { ... }
```

**Do** — public name, own file, in `presentation/widgets/`. The day a second
page wants `EmptyState`, you move it to `shared/widgets/`, you don't copy it.

`_PrivateWidget` is the worst of both worlds: too big to inline, too hidden
to reuse.

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

// application/template_controller.dart       — derived state
List<ProjectReceipt> get receiptsByDate =>
    [...state.receipts]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
```

### The Decision Flow

Before writing `_anything` inside a page file, answer in order:

1. **String for display?** → `presentation/<feature>_formatters.dart`.
2. **Enum → icon / color / label?** → `presentation/<feature>_mappers.dart`.
3. **Filtering / sorting / math on domain data?** → getter on state, or a
   method on the domain model.
4. **UI chunk bigger than ~15 lines, or used twice?** → public widget in
   `presentation/widgets/<name>.dart`.
5. **Used by a second feature?** → `lib/shared/widgets/`.
6. **None of the above and under ~15 lines?** → inline it. Do not wrap it in
   `_buildX()` or a private widget class.

## State And Data Flow

- Use Riverpod consistently for app state.
- Widgets send intent: `submit`, `refresh`, `setTrack`, `incrementSeats`.
- Controllers expose app state and intent-level methods.
- Business state lives outside widgets.
- Ephemeral UI state may stay in widgets when it is truly visual: focus,
  text controllers, hover, scroll position, tab selection.
- Avoid hidden writes in `build`; mutations should come from user actions,
  lifecycle hooks, or explicit effects.

### Do / Don't: Widgets Send Intent, Not Procedure

**Don't** — widget reads state, computes the next value, mutates directly:

```dart
onPressed: () {
  final controller = ref.read(templateControllerProvider.notifier);
  final next = controller.state.seats + 1;
  if (next <= 10) {
    controller.state = controller.state.copyWith(seats: next);
  }
}
```

**Do** — widget names the intent; bounds and `copyWith` live on the controller:

```dart
onPressed: () =>
    ref.read(templateControllerProvider.notifier).incrementSeats(),
```

## Use Cases

Use cases sit between controllers and repositories. A controller never imports
a repository directly — it always goes through a named use case.

- Use cases name the intent: `load`, `submit`, `confirm`, `watch`, `sync`.
- Use cases own business validation that belongs above the repository boundary.
- Use cases are the right place to combine multiple repositories, transform
  results, or apply pre-checks before the repository is called.
- A one-line use case that only forwards a repository call is acceptable when
  the operation name itself is the value. It may grow logic later without
  touching the controller.

### Do / Don't: Controllers Import Use Cases, Not Repositories

**Don't** — controller bypasses the use case layer:

```dart
// application/template_controller.dart
import '.../data/template_repository.dart'; // ← wrong

final result = await ref.read(templateRepositoryProvider).fetchReceipt(...);
```

**Do** — controller always goes through a named use case:

```dart
import '.../use_cases/load_template_receipt_use_case.dart'; // ← right

final loadReceipt = ref.watch(loadTemplateReceiptUseCaseProvider);
final result = await loadReceipt(track: track, seats: seats);
```

### Do / Don't: Business Validation Belongs In The Use Case

**Don't** — validation scattered between the controller and the repository:

```dart
// controller clamps as a business rule, not just a UI guard
await _loadReceipt(track: track, seats: seats.clamp(1, maxSeats));

// repository fake re-checks the same rule
if (seats < 1) return Err(ValidationFailure('...'));
```

**Do** — use case owns the rule; repository trusts its input:

```dart
// use case — single source of truth for this business rule
if (seats < 1) {
  return Future.value(
    const Err(ValidationFailure('At least one seat is required.')),
  );
}
return _repository.fetchReceipt(track: track, seats: seats);
```

### Do / Don't: Use Cases Work For Streams Too

When a feature needs live data, the repository exposes a `Stream` and the use
case forwards it. The controller's `build()` returns the stream and Riverpod
handles the subscription, converting each emission to `AsyncValue<T>`
automatically. No `StreamSubscription`, no `dispose`.

```dart
// use case
Stream<List<Order>> call(String userId) =>
    _repository.watchOrders(userId);

// controller
@override
Stream<List<Order>> build(String userId) {
  return ref.watch(watchOrdersUseCaseProvider).call(userId);
}
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

**Do** — repository returns `Result<T, Failure>`; controller maps it:

```dart
final result = await _repo.fetchReceipts();
state = result.when(
  ok:  (r) => state.copyWith(receipts: r, error: null),
  err: (f) => state.copyWith(error: f),
);
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

Private helpers and `_buildX` methods cannot be tested in isolation. If you
want a test for a piece of logic, it has to live in a domain file, a
controller, a formatter, a mapper, or a public widget. That is another reason
to extract it.
