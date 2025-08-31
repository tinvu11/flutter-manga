import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GlobalRepository _globalRepository;
  HomeBloc({required GlobalRepository globalRepository})
    : _globalRepository = globalRepository,
      super(const HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      await event.map(
        loadComics: (e) async {
          emit(const _Loading());

          List<String> categories = [
            'sap-ra-mat',
            'hoan-thanh',
            'truyen-moi',
            'dang-phat-hanh',
            'truyen-moi-cap-nhat',
          ];

          // Lấy dữ liệu home
          final homeResult = await _globalRepository.getHome();
          late final Comic homeData;
          Map<String, List<ItemsComic>> categoriesResults = {};

          homeResult.fold(
            (l) {
              emit(HomeState.error(message: l.toString()));
              return;
            },
            (r) {
              homeData = r;
            },
          );

          // Lấy dữ liệu theo từng state (song song để tăng performance)
          final futures = categories.map((category) async {
            final comicsByStateResult = await _globalRepository
                .getComicsByState(category, 1);
            return comicsByStateResult.fold(
              (l) {
                print("Failed to load comics for category $category: $l");
                return null; // skip nếu lỗi
              },
              (r) {
                print('Fetched comics for category: $r.data.ItemByStates');

                return MapEntry(category, r.data.items);
              },
            );
          });
          final results = await Future.wait(futures);
          // Lọc bỏ các kết quả null và thêm vào categoriesResults
          for (final result in results) {
            if (result != null) {
              categoriesResults[result.key] = result.value;
              print(
                'Added to categoriesResults: ${result.key} with ${result.value.length} items',
              );
            }
          }
          print('Final categoriesResults keys: ${categoriesResults.keys}');
          emit(_Loaded(home: homeData, comics: categoriesResults));
        },

        loadMoreComics: (e) async {
          if (state is! _Loaded) return;

          final currentState = state as _Loaded;

          if (currentState.hasReachedMax[e.category] == true) {
            return;
          }
          final comicsByStateResult = await _globalRepository.getComicsByState(
            e.category,
            e.page,
          );

          comicsByStateResult.fold(
            (l) {
              // Thay vì emit HomeState.error() làm mất dữ liệu,
              // bạn có thể emit một state mới với thông báo lỗi
              // hoặc dùng một stream riêng cho event để hiển thị SnackBar.
              // Tạm thời vẫn giữ state cũ.
              print("Failed to load more comics: $l");
            },
            (r) {
              // Tạo một bản sao của map state hiện tại để không làm thay đổi state gốc trực tiếp
              final updatedComicsMap = Map<String, List<ItemsComic>>.from(
                currentState.comics,
              );

              // Lấy danh sách truyện hiện tại của category, nếu chưa có thì tạo list rỗng
              final currentList = updatedComicsMap[e.category] ?? [];
              print(
                'Current list for category ${e.category}: ${currentList.length} items',
              );

              // Kết hợp danh sách cũ và mới bằng toán tử spread (...)
              List<ItemsComic> combinedList = {
                ...currentList,
                ...r.data.items,
              }.toList();

              // Cập nhật lại danh sách cho category đó trong map
              updatedComicsMap[e.category] = combinedList;

              // Cập nhật cờ hasReachedMax
              final updatedHasReachedMax = Map<String, bool>.from(
                currentState.hasReachedMax,
              );
              // Nếu API trả về danh sách rỗng, nghĩa là đã hết truyện
              if (r.data.items.isEmpty) {
                updatedHasReachedMax[e.category] = true;
              }

              // Emit state mới với dữ liệu đã được cập nhật
              emit(
                _Loaded(
                  comics: updatedComicsMap,
                  home: currentState.home, // Giữ lại dữ liệu home cũ
                  hasReachedMax: updatedHasReachedMax,
                ),
              );
            },
          );
        },
        refreshComics: (e) async {
          emit(const _Loading());
          List<String> categories = [
            'dang-phat-hanh',
            'hoan-thanh',
            'sap-ra-mat',
            'truyen-moi-cap-nhat',
          ];

          final homeResult = await _globalRepository.getHome();
          homeResult.fold(
            (l) => emit(HomeState.error(message: l.toString())),
            (r) => emit(_Loaded(home: r, comics: {})),
          );

          categories.map((e) async {
            final comicsByStateResult = await _globalRepository
                .getComicsByState(e, 1);
            comicsByStateResult.fold(
              (l) => emit(HomeState.error(message: l.toString())),
              (r) => emit(
                _Loaded(
                  comics: {
                    e: [...r.data.items],
                  },
                ),
              ),
            );
          });
        },
      );
    });
  }
}
