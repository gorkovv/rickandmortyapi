import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmortyapi/presentation/characters/bloc/characters_bloc.dart';
import 'package:rickandmortyapi/presentation/characters/bloc/characters_event.dart';
import 'package:rickandmortyapi/presentation/favorites/bloc/sort_cubit.dart';
import 'package:rickandmortyapi/presentation/main_screen.dart';
import 'package:rickandmortyapi/presentation/theme/app_theme.dart';
import 'package:rickandmortyapi/presentation/theme_cubit.dart';
import 'core/network/dio_client.dart';
import 'data/datasources/local_data_source.dart';
import 'data/datasources/remote_data_source.dart';
import 'data/repositories/character_repository_impl.dart';

DioClient dioClient = DioClient();
CharacterRepositoryImpl repository =
CharacterRepositoryImpl(RemoteDataSource(DioClient().dio), LocalDataSource());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          CharactersBloc(repository)
            ..add(LoadCharacters()),
        ),
        BlocProvider(

          /// Сортировка избранного - это отдельный кусок логики,
          /// который не должен быть связан с загрузкой персонажей.
          create: (context) => FavoritesSortCubit(),
        ),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}