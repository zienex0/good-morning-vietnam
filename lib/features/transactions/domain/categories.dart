import 'package:flutter_foundation_kit/features/transactions/domain/category.dart';

const List<Category> kBudgetingDefaultCategories = [
  Category(id: 'food', name: 'Food'),
  Category(id: 'coffee', name: 'Coffee'),
  Category(id: 'transport', name: 'Transport'),
  Category(id: 'lodging', name: 'Lodging'),
  Category(id: 'shopping', name: 'Shopping'),
  Category(id: 'tickets', name: 'Tickets'),
];

Category budgetingCategoryById(String id) {
  return kBudgetingDefaultCategories.firstWhere(
    (category) => category.id == id,
    orElse: () => kBudgetingDefaultCategories.first,
  );
}
