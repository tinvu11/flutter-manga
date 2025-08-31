import 'package:freezed_annotation/freezed_annotation.dart';
part 'comic_info.freezed.dart';
part 'comic_info.g.dart';

// Lớp gốc cho toàn bộ response
@freezed
abstract class ComicInfo with _$ComicInfo {
  const factory ComicInfo({
    required String status,
    required String message,
    required Data data,
  }) = _ComicInfo;

  factory ComicInfo.fromJson(Map<String, dynamic> json) =>
      _$ComicInfoFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({required Item item}) = _Data;
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class Item with _$Item {
  const factory Item({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String slug,
    required String content,
    required String status,
    @JsonKey(name: 'thumb_url') required String thumbUrl,
    required List<String> author,
    required List<Category> category,
    required List<Chapter> chapters,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    @JsonKey(name: 'server_name') required String serverName,
    @JsonKey(name: 'server_data') required List<ServerData> serverData,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}

@freezed
abstract class ServerData with _$ServerData {
  const factory ServerData({
    required String filename,
    @JsonKey(name: 'chapter_name') required String chapterName,
    @JsonKey(name: 'chapter_title') required String chapterTitle,
    @JsonKey(name: 'chapter_api_data') required String chapterApiData,
  }) = _ServerData;

  factory ServerData.fromJson(Map<String, dynamic> json) =>
      _$ServerDataFromJson(json);
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String slug,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
