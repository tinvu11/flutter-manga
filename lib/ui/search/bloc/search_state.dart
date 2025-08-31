part of 'search_bloc.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.loaded(List<ItemsComic> items) = _Loaded;
  const factory SearchState.error(String message) = _Error;
}
