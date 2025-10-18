import 'package:bloc/bloc.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:fluter_comic/data/models/chapter_content.dart';
import 'package:fluter_comic/data/repository/reading_repositoy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_bloc.freezed.dart';

part 'read_event.dart';
part 'read_state.dart';

class ReadBloc extends Bloc<ReadEvent, ReadState> {
  final GlobalRepository _globalRepository;
  final ReadingRepository _readingRepository;
  final String slug;
  ReadBloc({
    required GlobalRepository globalRepository,
    required ReadingRepository readingRepository,
    required this.slug,
  }) : _globalRepository = globalRepository,
       _readingRepository = readingRepository,
       super(const ReadState.initial()) {
    on<ReadEvent>((event, emit) async {
      await event.map(
        loadChapter: (e) async {
          emit(const ReadState.loading());
          final result = await _globalRepository.getChapterContent(e.url);
          emit(
            result.fold(
              (failure) => ReadState.error(message: failure.toString()),
              (content) => ReadState.loaded(content: content),
            ),
          );
        },
        saveReading: (e) async {
          final readings = await _readingRepository.getReading();
          if (!readings.contains(e.slug)) {
            await _readingRepository.saveReading(e.slug);
          }
        },
      );
    });
  }
  @override
  Future<void> close() async {
    print('ReadBloc is being closed. Saving reading state for slug: $slug');
    final readings = await _readingRepository.getReading();
    if (!readings.contains(this.slug)) {
      await _readingRepository.saveReading(this.slug);
    }
    return super.close();
  }
}
