import 'package:fluter_comic/data/models/comic_info.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:fluter_comic/data/repository/reading_repositoy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lib_reading_event.dart';
part 'lib_reading_state.dart';
part 'lib_reading_bloc.freezed.dart';

class LibReadingBloc extends Bloc<LibReadingEvent, LibReadingState> {
  final ReadingRepository _readingRepository;
  final GlobalRepository _globalRepository;
  LibReadingBloc({
    required ReadingRepository readingRepository,
    required GlobalRepository globalRepository,
  }) : _readingRepository = readingRepository,
       _globalRepository = globalRepository,
       super(const LibReadingState.initial()) {
    on<LibReadingEvent>((event, emit) async {
      await event.map(
        loadReadings: (e) async {
          emit(const LibReadingState.loading());
          final comics = await _readingRepository.getReading();

          final comicInfos = await Future.wait(
            comics.map((e) async {
              final result = await _globalRepository.getComicInfo(e);
              return result.fold((l) => null, (r) => r);
            }),
          );
          emit(LibReadingState.loaded(readings: comicInfos));
        },
        deleteReading: (e) async {
          await _readingRepository.deleteReading(e.slug);
          final comics = await _readingRepository.getReading();
          final comicInfos = await Future.wait(
            comics.map((e) async {
              final result = await _globalRepository.getComicInfo(e);
              return result.fold((l) => null, (r) => r);
            }),
          );
          emit(LibReadingState.loaded(readings: comicInfos));
        },
      );
    });
  }
}
