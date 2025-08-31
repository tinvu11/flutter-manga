import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GlobalRepository _globalRepository;
  SearchBloc({required GlobalRepository globalRepository})
    : _globalRepository = globalRepository,
      super(const SearchState.initial()) {
    on<SearchEvent>((event, emit) async {
      await event.map(
        search: (e) async {
          emit(const SearchState.loading());
          final query = e.query;
          final result = await _globalRepository.searchComics(query);
          result.fold(
            (failure) => emit(SearchState.error(failure.toString())),
            (comics) => emit(SearchState.loaded(comics.data.items)),
          );
        },
      );
    });
  }
}
