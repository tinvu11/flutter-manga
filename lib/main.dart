import 'package:firebase_core/firebase_core.dart';
import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/config/di.dart';
import 'package:fluter_comic/config/theme/theme.dart';
import 'package:fluter_comic/navigation/app_router.dart';
import 'package:fluter_comic/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DI().init();

  Bloc.observer = SimpleBlocObserver();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        BlocProvider<AuthenticationBloc>(
          create: (context) => DI().sl<AuthenticationBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp.router(
          title: 'Flutter Comic',
          routerConfig: AppRouter.router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          // debugShowCheckedModeBanner: false,
          // theme: ThemeData.from(
          //   colorScheme: ColorScheme.fromSeed(
          //     seedColor: Colors.red,
          //     brightness: Brightness.light,
          //   ),
          // ),
          // darkTheme: ThemeData.from(
          //   colorScheme: ColorScheme.fromSeed(
          //     seedColor: Colors.green,
          //     brightness: Brightness.dark,
          //   ),
          // ),
          // themeMode: ThemeMode.light,
        );
      },
    );
  }
}
