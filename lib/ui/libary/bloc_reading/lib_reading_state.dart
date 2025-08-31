part of 'lib_reading_bloc.dart';

@freezed
abstract class LibReadingState with _$LibReadingState {
  const factory LibReadingState.initial() = _Initial;
  const factory LibReadingState.loading() = _Loading;
  const factory LibReadingState.loaded({required List<ComicInfo?> readings}) =
      _Loaded;
  const factory LibReadingState.error({required String message}) = _Error;
}
