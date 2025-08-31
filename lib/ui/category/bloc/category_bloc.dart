import 'package:fluter_comic/data/models/categories.dart';
import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_bloc.freezed.dart';

part 'category_state.dart';
part 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GlobalRepository _globalRepository;
  CategoryBloc({required GlobalRepository globalRepository})
    : _globalRepository = globalRepository,
      super(const _Loading()) {
    on<CategoryEvent>((event, emit) async {
      await event.map(
        loadComics: (e) async {
          emit(const CategoryState.loading());
          final comicsByStateResult = await _globalRepository
              .getComicsByCategory(e.name, e.page);
          comicsByStateResult.fold(
            (exception) =>
                emit(CategoryState.error(message: exception.toString())),
            (comic) => emit(CategoryState.loaded(comic: comic)),
          );
        },
      );
    });
  }
}
