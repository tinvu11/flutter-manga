import 'package:fluter_comic/config/di.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:fluter_comic/data/repository/reading_repositoy.dart';
import 'package:fluter_comic/ui/category/bloc/category_bloc.dart';
import 'package:fluter_comic/ui/category/categroies_screen.dart';
import 'package:fluter_comic/ui/comment/bloc/comment_bloc.dart';
import 'package:fluter_comic/ui/home/bloc/home_bloc.dart';
import 'package:fluter_comic/ui/home/home_screen.dart';
import 'package:fluter_comic/ui/home/widget/view_all_widget.dart';
import 'package:fluter_comic/ui/home_navigation/home_navigation.dart';
import 'package:fluter_comic/ui/info/bloc/info_comic_bloc.dart';
import 'package:fluter_comic/ui/info/info_screen.dart';
import 'package:fluter_comic/ui/libary/bloc_marked/marked_bloc.dart';
import 'package:fluter_comic/ui/libary/bloc_reading/lib_reading_bloc.dart';
import 'package:fluter_comic/ui/libary/library_screen.dart';
import 'package:fluter_comic/ui/person/person_screen.dart';
import 'package:fluter_comic/ui/rate/bloc/rate_bloc.dart';
import 'package:fluter_comic/ui/read/bloc/read_bloc.dart';
import 'package:fluter_comic/ui/read/read_screen.dart';
import 'package:fluter_comic/ui/search/search_screen.dart';
import 'package:fluter_comic/ui/search/bloc/search_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'route_paths.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  // Lớp AppRouter định nghĩa cấu hình điều hướng cho ứng dụng Flutter, sử dụng package go_router để quản lý các route (đường dẫn) và điều hướng giữa các màn hình.
  // static Amplitude amplitude = DI().sl<Amplitude>();
  // Khởi tạo một instance của Amplitude (một thư viện phân tích sự kiện) thông qua dependency injection (DI) từ một service locator (sl).

  static final router = GoRouter(
    initialLocation:
        RoutePaths.home, // Chỉ định màn hình đầu tiên khi ứng dụng khởi động
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) {
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.info,
        builder: (context, state) {
          final slug = state.extra as String? ?? '';
          return MultiBlocProvider(
            providers: [
              BlocProvider<InfoComicBloc>(
                create: (context) => DI().sl<InfoComicBloc>(),
              ),
              BlocProvider<CommentBloc>(
                create: (context) => DI().sl<CommentBloc>(),
              ),
              BlocProvider<RateBloc>(create: (context) => DI().sl<RateBloc>()),
            ],
            child: InfoScreen(slug: slug),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.category,
        builder: (context, state) {
          final slug = state.extra as String? ?? '';
          return BlocProvider(
            create: (context) =>
                CategoryBloc(globalRepository: DI().sl<GlobalRepository>()),
            child: CategoriesScreen(slug: slug),
          );
        },
      ),

      GoRoute(
        path: RoutePaths.read,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;

          final url = params['url'];
          final slug = params['slug'];
          return MultiBlocProvider(
            providers: [
              BlocProvider<ReadBloc>(
                create: (context) => ReadBloc(
                  globalRepository: DI().sl<GlobalRepository>(),
                  readingRepository: DI().sl<ReadingRepository>(),
                  slug: slug,
                ),
              ),
            ],
            child: ReadScreen(url: url, slug: slug),
          );
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(create: (context) => DI().sl<HomeBloc>()),
              // BlocProvider<AuthenticationBloc>(
              //   create: (context) => DI().sl<AuthenticationBloc>(),
              // ),
              BlocProvider(
                create: (context) =>
                    // SearchBloc(globalRepository: DI().sl<GlobalRepository>()),
                    DI().sl<SearchBloc>(),
              ),
            ],
            child: HomeNavigation(navigationShell: navigationShell),
          );
        },

        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) {
                  return HomeScreen();
                },
              ),
              GoRoute(
                path: RoutePaths.viewAll,
                builder: (context, state) {
                  final data = state.extra! as Map<String, dynamic>;
                  return ViewAllWidget(
                    title: data['title'],
                    categorySlug: data['categorySlug'],
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.search,
                builder: (context, state) {
                  return SearchScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.library,
                builder: (context, state) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (context) => DI().sl<MarkedBloc>()),
                      BlocProvider(
                        create: (context) => DI().sl<LibReadingBloc>(),
                      ),
                    ],
                    child: LibraryScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.personal,
                builder: (context, state) {
                  return PersonScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
