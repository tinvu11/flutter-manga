part of 'home_bloc.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadComics() = _LoadComics;
  const factory HomeEvent.loadMoreComics({required String category, required int page}) = _LoadMoreComics;
  const factory HomeEvent.refreshComics() = _RefreshComics;
}
