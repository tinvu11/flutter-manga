import 'package:fluter_comic/data/models/comic_info.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:fluter_comic/data/repository/mark_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_comic_bloc.freezed.dart';

part 'info_comic_event.dart';
part 'info_comic_state.dart';

class InfoComicBloc extends Bloc<InfoComicEvent, InfoComicState> {
  final GlobalRepository _globalRepository;
  final MarkRepository _markRepository;
  InfoComicBloc({
    required GlobalRepository globalRepository,
    required MarkRepository markRepository,
  }) : _globalRepository = globalRepository,
       _markRepository = markRepository,
       super(const InfoComicState.initial()) {
    on<InfoComicEvent>((event, emit) async {
      await event.map(
        loadComic: (e) async {
          emit(const InfoComicState.loading());
          final isMarked = await _markRepository.getMarks().then(
            (marks) => marks.contains(e.slug),
          );
          final comic = await _globalRepository.getComicInfo(e.slug);
          comic.fold(
            (exception) =>
                emit(InfoComicState.error(message: exception.toString())),
            (comicInfo) => emit(
              InfoComicState.loaded(comic: comicInfo, isMarked: isMarked),
            ),
          );
        },
        addMark: (value) async {
          await _markRepository.saveMark(value.slug);
          emit(
            state.maybeMap(
              orElse: () => state,
              loaded: (value) {
                return value.copyWith(isMarked: true);
              },
            ),
          );
        },
        deleteMark: (value) async {
          await _markRepository.deleteMark(value.slug);
          print('emit dfdfdf');
          emit(
            state.maybeMap(
              orElse: () => state,
              loaded: (value) {
                return value.copyWith(isMarked: false);
              },
            ),
          );
        },
      );
    });
  }
}
