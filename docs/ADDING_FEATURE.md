# Adding A Feature — Step By Step

The working reference is `lib/features/template/`. Read it before writing a
new feature. Every step below maps to a real file in that folder.

---

## Step 1 — Decide: does it need a custom repository?

| Situation | What to do |
|---|---|
| Data lives in local Hive storage, nothing custom needed | Use `localRepository<T>(...)` — one line, no subclass |
| Need a custom Hive query, sort, or extra stream method | Extend `HiveLocalRepository<T>` |
| Data comes from a remote API or platform service | Implement `CrudRepository<T, String>` manually |

Jump to Step 2 regardless.

---

## Step 2 — Create the entity in `domain/`

One plain Dart class. No framework imports.

```dart
// lib/features/orders/domain/order.dart
class Order {
  const Order({this.id = '', required this.title, this.completedAt});

  final String id;
  final String title;
  final DateTime? completedAt;

  bool get isComplete => completedAt != null;
}
```

Put enums that belong to this entity here too
(`lib/features/orders/domain/order_status.dart`).

---

## Step 3 — Create the data layer in `data/`

### Fast path — one-liner provider

The whole data layer is one declaration. Serialization is three inline
functions — there is no separate codec class to write.

```dart
// lib/features/orders/data/order_repository.dart
import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_foundation_kit/features/orders/domain/order.dart';

final orderRepositoryProvider = localRepository<Order>(
  box: 'orders',
  id: (order) => order.id,
  toJson: (order) => {
    'id': order.id,
    'title': order.title,
    'completedAt': order.completedAt?.toIso8601String(),
  },
  fromJson: (json) => Order(
    id: json['id'] as String,
    title: json['title'] as String,
    completedAt: json['completedAt'] == null
        ? null
        : DateTime.parse(json['completedAt'] as String),
  ),
  sort: (a, b) => a.title.compareTo(b.title),
);
```

`localRepository` returns the `CrudRepository<Order, String>` surface, so the
controller depends on the interface and tests can override the provider with a
lightweight fake (no Hive box needed).

### Custom repository — when you need extra methods

Same three functions, now on a subclass that adds a query beyond plain CRUD.

```dart
abstract interface class OrderRepository
    implements CrudRepository<Order, String> {
  Stream<int> watchCompletedCount();
}

class HiveOrderRepository extends HiveLocalRepository<Order>
    implements OrderRepository {
  HiveOrderRepository()
      : super.lazy(
          openBox: () => openLocalHiveBox('orders'),
          id: (order) => order.id,
          toJson: (order) => {
            'id': order.id,
            'title': order.title,
            'completedAt': order.completedAt?.toIso8601String(),
          },
          fromJson: (json) => Order(
            id: json['id'] as String,
            title: json['title'] as String,
            completedAt: json['completedAt'] == null
                ? null
                : DateTime.parse(json['completedAt'] as String),
          ),
        );

  @override
  Stream<int> watchCompletedCount() =>
      watchAll().map((list) => list.where((o) => o.isComplete).length);
}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(OrderRepositoryRef ref) =>
    HiveOrderRepository();
```

---

## Step 4 — Create the controller in `application/`

Mix in `LocalCrudNotifier<T>`. `build()` is always `watchAll()`.

```dart
// lib/features/orders/application/orders_controller.dart
@riverpod
class OrdersController extends _$OrdersController
    with LocalCrudNotifier<Order> {
  @override
  CrudRepository<Order, String> get repository =>
      ref.read(orderRepositoryProvider);

  @override
  Stream<List<Order>> build() => watchAll();

  // Validation / normalisation — runs before every create.
  @override
  Future<Result<Order>> beforeCreate(Order draft) async {
    final title = draft.title.trim();
    if (title.isEmpty) {
      return const Err(ValidationFailure('Enter an order title.'));
    }
    // Stamp a unique id (the template uses the same microsecond strategy).
    return Ok(Order(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      completedAt: draft.completedAt,
    ));
  }

  // Side effects / rollback — runs after every create, success or failure.
  // Override afterUpdate / afterDelete the same way when needed.
  @override
  Future<void> afterCreate(Order entity, Result<Order> result) async {
    if (result case Ok()) {
      // e.g. send a notification, write to a second repo, etc.
    }
  }
}
```

**Hooks have access to `ref`** because the controller class extends a Riverpod
notifier. Read any provider in a hook — other repositories, services, loggers.

**You do not need a use case** unless the same multi-step logic must run from
two or more controllers.

---

## Step 5 — Create the page in `presentation/`

- Use `ConsumerStatefulWidget` when the page has local form state (pickers,
  text fields, counters). Business state stays in the controller.
- Render the async list with `AppAsyncValueView`.
- Call `controller.create` / `update` / `delete` and switch on the `Result`.

```dart
// lib/features/orders/presentation/orders_page.dart
class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});
  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncOrders = ref.watch(ordersControllerProvider);
    final controller = ref.read(ordersControllerProvider.notifier);

    return AppAsyncValueView(
      value: asyncOrders,
      onRetry: () => ref.invalidate(ordersControllerProvider),
      data: (orders) => AppSliverPage(
        title: 'Orders',
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.page),
            sliver: SliverList.list(
              children: [
                AppListSection(
                  children: [
                    for (final order in orders)
                      AppTile(
                        title: order.title,
                        subtitle: order.isComplete ? 'Done' : null,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
        bottomNavigationBar: AppBottomActionBar(
          child: AppButton.primary(
            label: 'Add order',
            expanded: true,
            onPressed: () async {
              final result = await controller.create(
                Order(title: _titleController.text),
              );
              if (!context.mounted) return;
              switch (result) {
                case Ok():
                  AppSnackBars.success(context, 'Order added.');
                case Err(failure: ValidationFailure(:final message)):
                  AppSnackBars.error(context, message);
                case Err():
                  AppSnackBars.error(context, 'Something went wrong.');
              }
            },
          ),
        ),
      ),
    );
  }
}
```

Add `feature_name_formatters.dart` for display strings and
`feature_name_mappers.dart` for enum → icon/color mappings.

---

## Step 6 — Wire routing

```dart
// lib/core/routing/app_routes.dart
static const String orders = '/orders';

// lib/core/routing/app_router.dart — add to the relevant branch or as a new GoRoute
GoRoute(path: AppRoutes.orders, builder: (_, __) => const OrdersPage()),
```

---

## Step 7 — Add tests

Mirror under `test/features/feature_name/`.

```
test/features/orders/
  domain/order_test.dart          — derived values, edge cases
  application/orders_controller_test.dart — beforeCreate validation, create/delete
```

Controller tests: inject a `_FakeRepository` via `ProviderContainer(overrides: [...])`.
Domain tests: plain Dart, no framework.

---

## Decision tree for less common situations

### "My operation isn't a create / update / delete"

Hooks are lifecycle callbacks for the three CRUD writes — they fire only when
you call the mixin's `create` / `update` / `delete`. A query, a calculation, a
bulk command, a sync — anything else — never touches a hook. Write it as an
explicit use case and call it directly.

```dart
// application/use_cases/monthly_revenue_use_case.dart
class MonthlyRevenueUseCase {
  const MonthlyRevenueUseCase(this._repository);
  final CrudRepository<ProjectReceipt, String> _repository;

  Future<Result<int>> call(DateTime month) async {
    final receipts = await _repository.watchAll().first;
    final total = receipts
        .where((r) => r.confirmedAt?.month == month.month)
        .fold<int>(0, (sum, r) => sum + r.total);
    return Ok(total);
  }
}

@riverpod
MonthlyRevenueUseCase monthlyRevenueUseCase(MonthlyRevenueUseCaseRef ref) =>
    MonthlyRevenueUseCase(ref.read(templateRepositoryProvider));
```

Expose it as a plain method on the controller (or read the provider straight
from the page); return the `Result` and let the page handle it:

```dart
class TemplateController extends _$TemplateController
    with LocalCrudNotifier<ProjectReceipt> {
  // ...repository getter + build() as usual...

  Future<Result<int>> revenueThisMonth() =>
      ref.read(monthlyRevenueUseCaseProvider)(DateTime.now());
}
```

Two notes:

- **No `mutate` here.** A `LocalCrudNotifier` controller is a `StreamNotifier`
  (its state is the watched list), so there is no `mutate`. Return the `Result`;
  if the operation wrote to the repository, the watched list re-emits on its own.
- **To bypass hooks on a write,** call the raw repository (`repository.create(...)`)
  instead of the mixin's `create(...)`. The mixin method runs `beforeCreate`; the
  repository method does not — useful for a bulk import where per-row validation
  should not fire.

### "My operation touches two repositories"

Override `beforeCreate` to write to the first repository and `afterCreate` to
roll back that write when `result` is `Err`. Both hooks have `ref`.

```dart
@override
Future<Result<Order>> beforeCreate(Order draft) async {
  // Reserve the slot first; abort the create if reservation fails.
  final reserved = await ref.read(slotRepositoryProvider).reserve(draft.slotId);
  if (reserved case Err(failure: final failure)) return Err(failure);
  return Ok(draft);
}

@override
Future<void> afterCreate(Order entity, Result<Order> result) async {
  // The order write failed after we reserved the slot — release it.
  if (result case Err()) {
    await ref.read(slotRepositoryProvider).release(entity.slotId);
  }
}
```

### "The same logic runs from two controllers"

Extract a use case in `application/use_cases/`. The use case takes a
repository interface (never a concrete class) via its constructor.

```dart
class CompleteOrderUseCase {
  const CompleteOrderUseCase(this._orders, this._notifications);
  final OrderRepository _orders;
  final NotificationService _notifications;

  Future<Result<Order>> call(String id) async { ... }
}

@Riverpod(keepAlive: true)
CompleteOrderUseCase completeOrderUseCase(CompleteOrderUseCaseRef ref) =>
    CompleteOrderUseCase(
      ref.watch(orderRepositoryProvider),
      ref.watch(notificationServiceProvider),
    );
```

Both controllers then read `completeOrderUseCaseProvider`.

### "The controller doesn't back a list — it's a write-only form"

Use `MutationNotifier<MyState>` on an `AsyncNotifier<MyState>` instead of
`LocalCrudNotifier`. The `mutate` helper handles loading → data/error state.

---

## Checklist before opening a PR

See the **Review Checklist** at the end of `docs/ARCHITECTURE.md`.
