import 'package:dartz/dartz.dart';
import 'package:fluter_comic/data/data_sources/comic_service.dart';
import 'package:fluter_comic/data/models/categories.dart';
import 'package:fluter_comic/data/models/chapter_content.dart';
import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/data/models/comic_info.dart';

abstract interface class GlobalRepository {
  Future<Either<Exception, Comic>> getHome();
  Future<Either<Exception, Categories>> getCategories();
  Future<Either<Exception, ComicInfo>> getComicInfo(String slug);
  Future<Either<Exception, Comic>> searchComics(String query);
  Future<Either<Exception, ChapterContent>> getChapterContent(String url);
  Future<Either<Exception, Comic>> getComicsByState(String state, int page);
  Future<Either<Exception, Comic>> getComicsByCategory(String name, int page);
}

class GlobalRepositoryImpl implements GlobalRepository {
  final ComicService _comicData;
  GlobalRepositoryImpl({required ComicService comicData})
    : _comicData = comicData;

  @override
  Future<Either<Exception, Comic>> getHome() async {
    try {
      var result = await _comicData.getHome();
      return Right(result);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, Categories>> getCategories() async {
    try {
      var result = await _comicData.getCategories();
      return Right(result);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, ComicInfo>> getComicInfo(String slug) async {
    try {
      var result = await _comicData.getComicInfo(slug);
      return Right(result);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, Comic>> searchComics(String query) async {
    try {
      var result = await _comicData.searchComics(query);
      return Right(result);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, ChapterContent>> getChapterContent(
    String url,
  ) async {
    try {
      var result = await _comicData.getChapterContent(url);
      return Right(result);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, Comic>> getComicsByState(
    String state,
    int page,
  ) async {
    try {
      var result = await _comicData.getComicsByState(state, page);
      return Right(result);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, Comic>> getComicsByCategory(
    String name,
    int page,
  ) async {
    try {
      var result = await _comicData.getComicsByCategory(name, page);
      return Right(result);
    } catch (e) {
      return Left(Exception(e));
    }
  }
}
