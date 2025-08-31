import 'package:freezed_annotation/freezed_annotation.dart';
part 'categories.freezed.dart';
part 'categories.g.dart';

@freezed
abstract class Categories with _$Categories {
  const factory Categories({
    required String status,
    required String message,
    required Data data,
  }) = _Categories;
  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({required List<Item> items}) = _Data;
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class Item with _$Item {
  const factory Item({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String slug,
  }) = _Item;
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
