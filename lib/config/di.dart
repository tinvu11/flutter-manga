import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/config/dio/app_dio.dart';
import 'package:fluter_comic/data/data_sources/auth/auth_service.dart';
import 'package:fluter_comic/data/data_sources/comic_service.dart';
import 'package:fluter_comic/data/data_sources/firestore/firestore_service.dart';
import 'package:fluter_comic/data/data_sources/pair_storage.dart';
import 'package:fluter_comic/data/repository/auth_repository.dart';
import 'package:fluter_comic/data/repository/firestore_repository.dart';
import 'package:fluter_comic/data/repository/global_repository.dart';
import 'package:fluter_comic/data/repository/mark_repository.dart';
import 'package:fluter_comic/data/repository/reading_repositoy.dart';
import 'package:fluter_comic/ui/comment/bloc/comment_bloc.dart';
import 'package:fluter_comic/ui/home/bloc/home_bloc.dart';
import 'package:fluter_comic/ui/info/bloc/info_comic_bloc.dart';
import 'package:fluter_comic/ui/libary/bloc_marked/marked_bloc.dart';
import 'package:fluter_comic/ui/libary/bloc_reading/lib_reading_bloc.dart';
import 'package:fluter_comic/ui/login/bloc/login_bloc.dart';
import 'package:fluter_comic/ui/rate/bloc/rate_bloc.dart';
import 'package:fluter_comic/ui/read/bloc/read_bloc.dart';
import 'package:fluter_comic/ui/search/bloc/search_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static DI? _instance;

  DI._();

  factory DI() {
    _instance ??= DI._();
    return _instance!;
  }

  final sl = GetIt.instance;

  Future<void> init() async {
    // Blocs
    sl.registerLazySingleton<LoginBloc>(() => LoginBloc());
    sl.registerLazySingleton<InfoComicBloc>(() => InfoComicBloc(globalRepository: sl(), markRepository: sl()));
    sl.registerLazySingleton<HomeBloc>(() => HomeBloc(globalRepository: sl()));
    sl.registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc()..add(AuthenticationEvent.appStarted()));
    sl.registerLazySingleton<SearchBloc>(() => SearchBloc(globalRepository: sl()));
    sl.registerLazySingleton<CommentBloc>(() => CommentBloc(firestoreRepository: sl()));
    sl.registerLazySingleton<RateBloc>(() => RateBloc(firestoreRepository: sl()));
    sl.registerLazySingleton<MarkedBloc>(() => MarkedBloc(markRepository: sl(), globalRepository: sl()));
    sl.registerLazySingleton<LibReadingBloc>(() => LibReadingBloc(readingRepository: sl(), globalRepository: sl()));

    // Dio
    sl.registerLazySingleton<Dio>(() => ComicDio(connectivity: Connectivity()).dio);

    sl.registerLazySingleton<PairStorage>(() => SharedPreferencesMarkStorage(prefs: sl()));
    final prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);

    sl.registerLazySingleton<MarkRepository>(() => MarkRepositoryImpl(pairStorage: sl()));
    sl.registerLazySingleton<ReadingRepository>(() => ReadingRepositoryImpl(pairStorage: sl()));

    // Services
    sl.registerLazySingleton<ComicService>(() => ComicServiceImpl(dio: sl()));
    sl.registerLazySingleton<GlobalRepository>(() => GlobalRepositoryImpl(comicData: sl()));

    // Authentication related services
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
    sl.registerLazySingleton<AuthService>(
      () => AuthServiceImpl(firebaseAuth: sl(), firestore: sl(), googleSignIn: sl()),
    );
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authService: sl()));

    sl.registerLazySingleton<FirestoreService>(() => FirestoreServiceImpl(firestore: sl()));

    sl.registerLazySingleton<FirestoreRepository>(() => FirestoreRepositoryImpl(firestoreService: sl()));
  }
}
