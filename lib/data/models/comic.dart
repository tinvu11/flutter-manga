import 'package:freezed_annotation/freezed_annotation.dart';

part 'comic.freezed.dart';
part 'comic.g.dart';

@freezed
abstract class Comic with _$Comic {
  const factory Comic({
    required Data data,
    required String status,
    required String message,
  }) = _Comic;

  factory Comic.fromJson(Map<String, dynamic> json) => _$ComicFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({required List<ItemsComic> items}) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class ItemsComic with _$ItemsComic {
  const factory ItemsComic({
    // @JsonKey(name: '_id') required String id,
    required String name,
    required String slug,
    @JsonKey(name: 'thumb_url') required String thumbUrl,
  }) = _ItemsComic;

  factory ItemsComic.fromJson(Map<String, dynamic> json) =>
      _$ItemsComicFromJson(json);
}
