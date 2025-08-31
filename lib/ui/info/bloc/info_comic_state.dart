part of 'info_comic_bloc.dart';

@freezed
abstract class InfoComicState with _$InfoComicState {
  const factory InfoComicState.initial() = _Initial;
  const factory InfoComicState.loading() = _Loading;
  const factory InfoComicState.loaded({
    required ComicInfo comic,
    required bool isMarked,
  }) = _Loaded;
  const factory InfoComicState.error({required String message}) = _Error;
}
