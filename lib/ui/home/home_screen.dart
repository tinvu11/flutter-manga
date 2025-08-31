import 'package:fluter_comic/ui/home/bloc/home_bloc.dart';
import 'package:fluter_comic/ui/home/widget/banner_widget.dart';
import 'package:fluter_comic/ui/home/widget/categories_widget.dart';
import 'package:fluter_comic/ui/home/widget/states_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeEvent.loadComics());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (categoriesData, bannerData, hasMax) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(const HomeEvent.loadComics());
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 480,
                        child: BannerWidget(home: bannerData!),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chứa danh sách các thể loại
                            CategoriesWidgetWidget(),

                            // Chứa danh sách các trạng thái truyện và items của chúng
                            SizedBox(height: 20),
                            StatesWidget(categoriesData: categoriesData),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (error) {
              return Center(
                child: Text(
                  'Error loading banner',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
