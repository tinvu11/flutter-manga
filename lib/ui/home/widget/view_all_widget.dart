import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluter_comic/navigation/app_router.dart';
import 'package:fluter_comic/ui/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ViewAllWidget extends StatefulWidget {
  final String title;
  final String categorySlug;
  const ViewAllWidget({
    super.key,
    required this.title,
    required this.categorySlug,
  });

  @override
  State<ViewAllWidget> createState() => _ViewAllWidgetState();
}

class _ViewAllWidgetState extends State<ViewAllWidget> {
  bool _isLoadingMore = false;
  int pageNumbers = 2;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        state.whenOrNull(
          loaded: (_, _, _) {
            if (_isLoadingMore) {
              _isLoadingMore = false;
            }
          },
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => Center(child: CircularProgressIndicator()),
          loading: () => Center(child: CircularProgressIndicator()),
          loaded: (comics, hasReachedMax, categorySlug) {
            final comicsList = comics[widget.categorySlug] ?? [];
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(title: Text(widget.title)),
              body: NotificationListener<ScrollNotification>(
                onNotification: (notification) => _handleScrollNotification(
                  notification,
                  widget.categorySlug,
                  context,
                ),
                child: GridView.builder(
                  itemCount: comicsList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push(RoutePaths.info);
                          },
                          child: SizedBox(
                            height: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://img.otruyenapi.com/uploads/comics/${comicsList[index].thumbUrl}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: 130,

                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            comicsList[index].name,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
          error: (message) {
            return Center(child: Text(message));
          },
        );
      },
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
        context.read<HomeBloc>().add(
          HomeEvent.loadMoreComics(category: category, page: pageNumbers),
        );
        pageNumbers++;
      }
    }
    return false;
  }
}
