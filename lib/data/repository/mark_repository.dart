import 'package:fluter_comic/data/data_sources/pair_storage.dart';

abstract class MarkRepository {
  Future<void> saveMark(String mark);
  Future<List<String>> getMarks();
  Future<void> deleteMark(String mark);
}

class MarkRepositoryImpl implements MarkRepository {
  final PairStorage _pairStorage;

  MarkRepositoryImpl({required PairStorage pairStorage})
    : _pairStorage = pairStorage;

  @override
  Future<void> saveMark(String mark) async {
    await _pairStorage.saveMark(mark);
  }

  @override
  Future<List<String>> getMarks() async {
    return await _pairStorage.getMark();
  }

  @override
  Future<void> deleteMark(String mark) async {
    await _pairStorage.deleteMark(mark);
  }
}
