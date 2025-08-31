part of 'info_comic_bloc.dart';

@freezed
abstract class InfoComicEvent with _$InfoComicEvent {
  const factory InfoComicEvent.loadComic(String slug) = _LoadComic;
  const factory InfoComicEvent.addMark(String slug) = _AddMark;
  const factory InfoComicEvent.deleteMark(String slug) = _DeleteMark;
}
