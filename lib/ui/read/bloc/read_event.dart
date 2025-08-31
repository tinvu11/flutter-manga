part of 'read_bloc.dart';

@freezed
abstract class ReadEvent with _$ReadEvent {
  const factory ReadEvent.loadChapter({required String url}) = _LoadChapter;
  const factory ReadEvent.saveReading({required String slug}) = _SaveReading;
}
