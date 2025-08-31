import 'package:shared_preferences/shared_preferences.dart';

abstract interface class PairStorage {
  Future<void> saveMark(String mark);
  Future<List<String>> getMark();
  Future<void> deleteMark(String mark);
  Future<void> saveReading(String mark);
  Future<List<String>> getReading();
  Future<void> deleteReading(String mark);
}

class SharedPreferencesMarkStorage implements PairStorage {
  static const String _markedComicsKey = 'marked_comics';
  static const String _readingComicsKey = 'reading_comics';

  final SharedPreferences _prefs;

  SharedPreferencesMarkStorage({required SharedPreferences prefs})
    : _prefs = prefs;

  @override
  Future<void> saveMark(String mark) async {
    await _prefs.setStringList(_markedComicsKey, [
      ...?_prefs.getStringList(_markedComicsKey),
      mark,
    ]);
  }

  @override
  Future<List<String>> getMark() async {
    return _prefs.getStringList(_markedComicsKey) ?? [];
  }

  @override
  Future<void> deleteMark(String mark) async {
    final marks = [...?_prefs.getStringList(_markedComicsKey)];
    marks.remove(mark);
    await _prefs.setStringList(_markedComicsKey, marks);
  }

  @override
  Future<void> saveReading(String slug) async {
    await _prefs.setStringList(_readingComicsKey, [
      ...?_prefs.getStringList(_readingComicsKey),
      slug,
    ]);
  }

  @override
  Future<List<String>> getReading() async {
    return _prefs.getStringList(_readingComicsKey) ?? [];
  }

  @override
  Future<void> deleteReading(String slug) async {
    final readings = [...?_prefs.getStringList(_readingComicsKey)];
    readings.remove(slug);
    await _prefs.setStringList(_readingComicsKey, readings);
  }
}
