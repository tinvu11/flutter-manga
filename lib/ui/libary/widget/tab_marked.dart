import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluter_comic/navigation/app_router.dart';
import 'package:fluter_comic/ui/libary/bloc_marked/marked_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TabMarked extends StatefulWidget {
  const TabMarked({super.key});

  @override
  State<TabMarked> createState() => _TabMarkedState();
}

class _TabMarkedState extends State<TabMarked>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // Load comics when the tab is initialized
    context.read<MarkedBloc>().add(const MarkedEvent.loadComics());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<MarkedBloc, MarkedState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('Chưa có dữ liệu')),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (comics) {
            if (comics.isEmpty) {
              return const Center(child: Text('Chưa có dữ liệu'));
            }
            final newList = comics.where((comic) => comic != null).toList();
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MarkedBloc>().add(const MarkedEvent.loadComics());
              },
              child: GridView.builder(
                itemCount: newList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.61,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  final comic = newList[index]!.data.item;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push(RoutePaths.info, extra: comic.slug);
                        },
                        child: SizedBox(
                          height: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://img.otruyenapi.com/uploads/comics/${comic.thumbUrl}',
                            ),
                          ),
                        ),
                      ),
                      Text(
                        comic.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
          error: (error) => Center(child: Text(error.toString())),
        );
      },
    );
  }
}
