part of 'category_bloc.dart';

@freezed
abstract class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.loadComics({
    required String name,
    required int page,
  }) = _LoadComics;
}
