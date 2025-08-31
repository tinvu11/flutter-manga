import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/navigation/app_router.dart';
import 'package:fluter_comic/ui/category/bloc/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatefulWidget {
  final String slug;
  const CategoriesScreen({super.key, required this.slug});

  @override
  State<CategoriesScreen> createState() => _State();
}

class _State extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(CategoryEvent.loadComics(name: widget.slug, page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const Center(child: Text('Select a category')),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          loaded: (state) => _buildComicList(state.comic),
          error: (state) => Center(child: Text('Error: ${state.message}')),
        );
      },
    );
  }

  Widget _buildComicList(Comic comic) {
    final textTheme = Theme.of(context).textTheme;

    final data = comic.data.items;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(widget.slug), floating: true, snap: true),
          SliverAnimatedGrid(
            initialItemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.57,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                opacity: animation,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(RoutePaths.info, extra: data[index].slug);
                      },
                      child: SizedBox(
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: 'https://img.otruyenapi.com/uploads/comics/${data[index].thumbUrl}',
                            // 'https://img.otruyenapi.com/uploads/comics/kougekiryoku-zero-kara-hajimeru-kenseitan-thumb.jpg',
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
                        data[index].name,
                        style: textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
