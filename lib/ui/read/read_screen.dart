import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluter_comic/ui/read/bloc/read_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class ReadScreen extends StatefulWidget {
  final String url;
  final String slug;
  const ReadScreen({super.key, required this.url, required this.slug});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReadBloc>().add(ReadEvent.loadChapter(url: widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadBloc, ReadState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => Center(child: const Text('No content available')),
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
          loaded: (content) {
            final chapterName = content.data.item.chapterName;
            final chapterPath = content.data.item.chapterPath;
            final chapterImage = content.data.item.chapterImage;
            var logger = Logger();

            return Scaffold(
              // body: NestedScrollView(
              //   headerSliverBuilder: (context, innerBoxIsScrolled) {
              //     return [
              //       SliverAppBar(
              //         title: Text('Chương $chapterName'),
              //         titleSpacing: 0,
              //         floating: true,
              //         snap: true,
              //       ),
              //     ];
              //   },
              //   body: ListView.builder(
              //     itemCount: chapterImage.length,
              //     itemBuilder: (context, index) {
              //       return CachedNetworkImage(
              //         imageUrl:
              //             'https://sv1.otruyencdn.com/${chapterPath}/${chapterImage[index].imageFile}',
              //         errorWidget: (context, url, error) =>
              //             const Center(child: Icon(Icons.error)),
              //       );
              //     },
              //   ),
              // ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    leading: GestureDetector(
                      onTap: () {
                        context.read<ReadBloc>().add(
                          ReadEvent.saveReading(slug: widget.slug),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    title: Text('Chương $chapterName'),
                    titleSpacing: 0,
                    floating: true,
                    snap: true,
                  ),

                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(chapterImage.length, (index) {
                          return CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              height: MediaQuery.of(context).size.height,
                              child: Center(child: CircularProgressIndicator()),
                              // child: Text('Loading...$index'),
                            ),
                            imageUrl:
                                'https://sv1.otruyencdn.com/${chapterPath}/${chapterImage[index].imageFile}',
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (state) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${state.toString()}')),
          ),
        );
      },
    );
  }
}
