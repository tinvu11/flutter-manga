part of 'read_bloc.dart';

@freezed
abstract class ReadState with _$ReadState {
  const factory ReadState.initial() = _Initial;
  const factory ReadState.loading() = _Loading;
  const factory ReadState.loaded({required ChapterContent content}) = _Loaded;
  const factory ReadState.error({required String message}) = _Error;
}
