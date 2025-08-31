import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/data/models/comic_info.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:fluter_comic/data/repository/mark_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'marked_bloc.freezed.dart';
part 'marked_event.dart';
part 'marked_state.dart';

class MarkedBloc extends Bloc<MarkedEvent, MarkedState> {
  final MarkRepository _markRepository;
  final GlobalRepository _globalRepository;
  MarkedBloc({
    required MarkRepository markRepository,
    required GlobalRepository globalRepository,
  }) : _markRepository = markRepository,
       _globalRepository = globalRepository,
       super(const MarkedState.initial()) {
    on<MarkedEvent>((event, emit) async {
      await event.map(
        loadComics: (e) async {
          emit(const MarkedState.loading());
          final comics = await _markRepository.getMarks();

          final comicInfos = await Future.wait(
            comics.map((e) async {
              final result = await _globalRepository.getComicInfo(e);
              return result.fold((l) => null, (r) => r);
            }),
          );
          emit(MarkedState.loaded(comicInfos));
        },
        checkMarked: (e) async {
          final result = await _markRepository.getMarks();
          final isMarked = result.contains(e.slug);
          return isMarked;
        },
        addComic: (e) async {
          // Handle adding a comic
        },
        removeComic: (e) async {
          // Handle removing a comic
        },
      );
    });
  }
}
