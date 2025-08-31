part of 'marked_bloc.dart';

@freezed
abstract class MarkedState with _$MarkedState {
  const factory MarkedState.initial() = _Initial;
  const factory MarkedState.loading() = _Loading;
  const factory MarkedState.loaded(List<ComicInfo?> comics) = _Loaded;
  const factory MarkedState.error(String message) = _Error;
}
