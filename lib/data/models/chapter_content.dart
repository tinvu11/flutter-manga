import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_content.freezed.dart';
part 'chapter_content.g.dart';

@freezed
abstract class ChapterContent with _$ChapterContent {
  const factory ChapterContent({
    required String status,
    required String message,
    required Data data,
  }) = _ChapterContent;

  factory ChapterContent.fromJson(Map<String, dynamic> json) =>
      _$ChapterContentFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({
    @JsonKey(name: 'domain_cdn') required String domainCdn,
    required Item item,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class Item with _$Item {
  const factory Item({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'comic_name') required String comicName,
    @JsonKey(name: 'chapter_name') required String chapterName,
    @JsonKey(name: 'chapter_title') required String chapterTitle,
    @JsonKey(name: 'chapter_path') required String chapterPath,
    @JsonKey(name: 'chapter_image') required List<ChapterImage> chapterImage,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
abstract class ChapterImage with _$ChapterImage {
  const factory ChapterImage({
    @JsonKey(name: 'image_page') required int imagePage,
    @JsonKey(name: 'image_file') required String imageFile,
  }) = _ChapterImage;

  factory ChapterImage.fromJson(Map<String, dynamic> json) =>
      _$ChapterImageFromJson(json);
}
