import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluter_comic/config/theme/app_colors.dart';
import 'package:fluter_comic/navigation/app_router.dart';
import 'package:fluter_comic/ui/info/bloc/info_comic_bloc.dart';
import 'package:fluter_comic/ui/info/widgets/button.dart';
import 'package:fluter_comic/ui/info/widgets/function_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class InfoScreen extends StatefulWidget {
  final String slug;
  const InfoScreen({super.key, required this.slug});
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InfoComicBloc>().add(InfoComicEvent.loadComic(widget.slug));
  }

  @override
  void dispose() {
    super.dispose();
    context.read<InfoComicBloc>().close();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<InfoComicBloc, InfoComicState>(
      builder: (context, state) {
        return state.maybeWhen(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) {
            return Center(
              child: Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            );
          },
          loaded: (comic, isMarked) {
            final isMark = isMarked;
            final data = comic.data.item;
            return DefaultTabController(
              length: 2, // Assuming 3 tabs
              child: Scaffold(
                appBar: AppBar(title: const Text('Thông tin truyện')),
                body: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 250, // Thêm height cố định
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://img.otruyenapi.com/uploads/comics/${data.thumbUrl}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 250, // Thêm height cố định
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          // Style mặc định cho cả dòng, lấy từ bodyMedium
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Tác giả: ',
                                              // Style riêng cho phần tiêu đề (in đậm)
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: data.author
                                                  .toString()
                                                  .replaceAll('[', '')
                                                  .replaceAll(']', ''),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      RichText(
                                        maxLines: 2,
                                        text: TextSpan(
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(),
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Category: ',
                                              // Style riêng cho phần tiêu đề (in đậm)
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: data.category
                                                  .map((e) => e.name)
                                                  .join(', '),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 8),
                                      RichText(
                                        text: TextSpan(
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(),
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Total Chapters: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: data.chapters.isEmpty
                                                  ? '0'
                                                  : '${data.chapters.map((e) => e.serverData.length).reduce((a, b) => a + b)}',
                                            ),
                                          ],
                                        ),
                                      ),

                                      const Spacer(), // Bây giờ có thể dùng Spacer vì có height cố định
                                      ButtonInfo(
                                        text: 'Đọc ngay',
                                        flex: 0,
                                        backgroundColor:
                                            colorScheme.primaryContainer,
                                        foregroundColor: Colors.white,
                                        ontap: () {
                                          context.push(
                                            RoutePaths.read,
                                            extra: {
                                              'url': data
                                                  .chapters[0]
                                                  .serverData[0]
                                                  .chapterApiData,
                                              'slug': data.slug,
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mô tả',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.content
                                    .toString()
                                    .replaceAll('<p>', '')
                                    .replaceAll('</p>', ''),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RateAllWidget(
                            isMarked: isMark,
                            totalChapter: 10,
                            slug: data.slug,
                            title: data.name,
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarDelegate(
                          TabBar(
                            tabs: [
                              Tab(text: ('Chương')),
                              // Tab(text: ('Comments')),
                            ],
                            tabAlignment: TabAlignment.start,
                            splashBorderRadius: BorderRadius.circular(20),
                            labelColor: colorScheme.primary,
                            indicator: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            // dividerColor: Colors.amber,
                            dividerColor: Colors.transparent,
                            isScrollable: true,
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [TabContent()],
                  ), // Use the defined TabBarView as the body
                ),
              ),
            );
          },
          orElse: () => Center(
            child: Text(
              'Error loading comic information',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
            ),
          ),
        );
      },
    );
  }
}

// Widget nội dung từng tab
class TabContent extends StatelessWidget {
  const TabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<InfoComicBloc, InfoComicState>(
      builder: (context, state) {
        final items = state.maybeMap(
          orElse: () => null,
          loaded: (value) {
            if (value.comic.data.item.chapters.isEmpty) {
              return [];
            }
            return value.comic.data.item.chapters[0].serverData;
          },
        );
        if (items == null || items.isEmpty) {
          return Center(child: Text('Không có chương nào'));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final state = context.read<InfoComicBloc>().state;
                  final slug = state.maybeMap(
                    orElse: () => '',
                    loaded: (value) => value.comic.data.item.slug,
                  );

                  context.push(
                    RoutePaths.read,
                    extra: {'url': items[index].chapterApiData, 'slug': slug},
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'Chương ${index + 1}',
                      style: TextStyle(color: colorScheme.onSecondary),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Custom SliverPersistentHeaderDelegate để giữ TabBar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}
