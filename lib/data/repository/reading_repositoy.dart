import 'package:fluter_comic/data/data_sources/pair_storage.dart';

abstract class ReadingRepository {
  Future<void> saveReading(String slug);
  Future<List<String>> getReading();
  Future<void> deleteReading(String slug);
}

class ReadingRepositoryImpl implements ReadingRepository {
  final PairStorage _pairStorage;

  ReadingRepositoryImpl({required PairStorage pairStorage})
    : _pairStorage = pairStorage;

  @override
  Future<void> saveReading(String slug) async {
    await _pairStorage.saveReading(slug);
  }

  @override
  Future<List<String>> getReading() async {
    return await _pairStorage.getReading();
  }

  @override
  Future<void> deleteReading(String slug) async {
    await _pairStorage.deleteReading(slug);
  }
}
