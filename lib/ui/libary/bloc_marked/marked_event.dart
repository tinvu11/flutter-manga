part of 'marked_bloc.dart';

@freezed
abstract class MarkedEvent with _$MarkedEvent {
  const factory MarkedEvent.loadComics() = _LoadComics;
  const factory MarkedEvent.checkMarked({required String slug}) = _CheckMarked;
  const factory MarkedEvent.addComic(Comic comic) = _AddComic;
  const factory MarkedEvent.removeComic(Comic comic) = _RemoveComic;
}
