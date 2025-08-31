import 'package:dio/dio.dart';
import 'package:fluter_comic/data/models/categories.dart';
import 'package:fluter_comic/data/models/chapter_content.dart';
import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/data/models/comic_info.dart';

abstract interface class ComicService {
  Future<Comic> getHome();
  Future<Categories> getCategories();
  Future<Comic> searchComics(String query);
  Future<ComicInfo> getComicInfo(String slug);
  Future<ChapterContent> getChapterContent(String url);
  Future<Comic> getComicsByState(String state, int page);
  Future<Comic> getComicsByCategory(String name, int page);
}

class ComicServiceImpl implements ComicService {
  ComicServiceImpl({required Dio dio}) : _dio = dio;

  // lấy danh sách các truyện dựa vào trạng thái (ví dụ: đang cập nhật, đã hoàn thành)
  final Dio _dio;

  @override
  Future<Comic> getComicsByState(String state, int page) async {
    print('Fetching comics by state: $state, page: $page');
    final response = await _dio.get(
      'https://otruyenapi.com/v1/api/danh-sach/$state',
      queryParameters: {'page': page},
    );
    return Comic.fromJson(response.data);
  }

  // Lấy các hình ảnh của chương truyện
  @override
  Future<ChapterContent> getChapterContent(String url) async {
    final response = await _dio.get(url);
    return ChapterContent.fromJson(response.data);
  }

  // Lấy các thông tin truyện cho trang chi tiết
  @override
  Future<ComicInfo> getComicInfo(String slug) async {
    final response = await _dio.get(
      'https://otruyenapi.com/v1/api/truyen-tranh/$slug',
    );
    return ComicInfo.fromJson(response.data);
  }

  @override
  Future<Comic> searchComics(String query) async {
    final response = await _dio.get(
      'https://otruyenapi.com/v1/api/tim-kiem',
      queryParameters: {'keyword': query},
    );
    return Comic.fromJson(response.data);
  }

  // Lấy các truyện ở home
  @override
  Future<Comic> getHome() async {
    final response = await _dio.get('https://otruyenapi.com/v1/api/home');
    return Comic.fromJson(response.data);
  }

  // Lấy danh sách các thể loại truyện
  @override
  Future<Categories> getCategories() async {
    final response = await _dio.get('the-loai');
    return Categories.fromJson(response.data);
  }

  // Lấy danh sách truyện theo thể loại
  @override
  Future<Comic> getComicsByCategory(String name, int page) async {
    final response = await _dio.get(
      'https://otruyenapi.com/v1/api/the-loai/$name',
      queryParameters: {'page': page},
    );
    return Comic.fromJson(response.data);
  }
}
