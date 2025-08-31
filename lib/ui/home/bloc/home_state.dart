part of 'home_bloc.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    @Default({}) Map<String, List<ItemsComic>> comics,
    Comic? home,
    @Default({}) Map<String, bool> hasReachedMax,
  }) = _Loaded;
  const factory HomeState.error({required String message}) = _Error;
}
