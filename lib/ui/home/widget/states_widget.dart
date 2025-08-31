import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/navigation/app_router.dart';
import 'package:fluter_comic/ui/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StatesWidget extends StatefulWidget {
  final Map<String, List<ItemsComic>> categoriesData;

  const StatesWidget({super.key, required this.categoriesData});

  @override
  State<StatesWidget> createState() => _StatesWidgetState();
}

class _StatesWidgetState extends State<StatesWidget> {
  bool _isLoadingMore = false;
  Map<String, int> pageNumbers = {};

  List<String> categories = [
    'Sắp ra mắt',
    'Hoàn thành',
    'Truyện mới',
    'Đang phát hành',
    'Truyện mới cập nhật',
  ];
  List<String> categoriesSlug = [
    'sap-ra-mat',
    'hoan-thanh',
    'truyen-moi',
    'dang-phat-hanh',
    'truyen-moi-cap-nhat',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        state.whenOrNull(
          loaded: (_, _, _) {
            if (_isLoadingMore) {
              _isLoadingMore = false;
            }
          },
        );
      },
      child: Column(
        children: List.generate(categories.length, (index) {
          if (widget.categoriesData.containsKey(categoriesSlug[index]) ==
              false) {
            return const SizedBox.shrink();
          }
          final category = categories[index];
          List<ItemsComic> comics =
              widget.categoriesData[categoriesSlug[index]]!;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(
                          RoutePaths.viewAll,
                          extra: {
                            'title': category,
                            'categorySlug': categoriesSlug[index],
                          },
                        );
                      },
                      child: Icon(Icons.navigate_next, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) => _handleScrollNotification(
                    notification,
                    categoriesSlug[index],
                    context,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        comics.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle tap event
                                  context.push(
                                    RoutePaths.info,
                                    extra: comics[index].slug,
                                  );
                                },
                                child: SizedBox(
                                  height: 180,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://img.otruyenapi.com/uploads/comics/${comics[index].thumbUrl}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 130,

                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  comics[index].name,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
    String category,
    BuildContext context,
  ) {
    // Kiểm tra nếu đang cuộn và đã cuộn gần đến cuối
    if (notification is ScrollUpdateNotification &&
        notification.metrics.pixels >=
            notification.metrics.maxScrollExtent * 0.9) {
      final currentState = context.read<HomeBloc>().state;
      final loadedState = currentState.mapOrNull(loaded: (state) => state);

      if (loadedState == null || _isLoadingMore == true) {
        return false;
      }

      final hasReachedMax = loadedState.hasReachedMax[category] ?? false;

      if (hasReachedMax == false) {
        _isLoadingMore = true;
        int currentPage = pageNumbers[category] ?? 2;
        context.read<HomeBloc>().add(
          HomeEvent.loadMoreComics(category: category, page: currentPage),
        );
        pageNumbers[category] = currentPage + 1;
      }
    }
    return false;
  }
}
