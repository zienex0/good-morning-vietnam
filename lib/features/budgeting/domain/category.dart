import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
class Category with _$Category {
  const Category._();

  const factory Category({
    required String id,
    required String name,
    String? parentId,
    String? icon,
    String? color,
  }) = _Category;

  bool get isRoot => parentId == null;
}
