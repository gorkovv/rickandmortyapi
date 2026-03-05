import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/character.dart';
import '../characters/bloc/characters_bloc.dart';
import '../characters/bloc/characters_state.dart';
import '../main_screen.dart';
import '../widgets/character_card.dart';
import 'bloc/sort_cubit.dart';

enum FavoritesSort { name, status, species }

class FavoritesScreen extends StatefulWidget  implements AppBarScreen{
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.star),
          const SizedBox(width: 8),
          Text('Избранное'),
        ],
      ),
      actions: [
        PopupMenuButton<FavoritesSort>(
          icon: const Icon(Icons.sort),
          onSelected: (value) {
            context.read<FavoritesSortCubit>().changeSort(value);
          },
          itemBuilder: (context) => const [
            /// По хорошему нужно делать чекбокс рядом с каждым пунктом
            /// показывать какой вид сортировки сейчас активен.
            PopupMenuItem(
              value: FavoritesSort.name,
              child: Text('Сортировать по имени'),
            ),
            PopupMenuItem(
              value: FavoritesSort.status,
              child: Text('Сортировать по статусу'),
            ),
            PopupMenuItem(
              value: FavoritesSort.species,
              child: Text('Сортировать по виду'),
            ),
          ],
        ),
      ],
    );
  }
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final GlobalKey<AnimatedListState> _listKey =
  GlobalKey<AnimatedListState>();
  FavoritesSort _sort = FavoritesSort.name;
  //CharactersBloc get _bloc => context.read<CharactersBloc>();

  List<Character> _favorites = [];

  @override
  void initState() {
    super.initState();
  }

  List<Character> _buildSortedList(CharactersState state) {
    if(state.favorites.isEmpty) return state.favorites;
    /// Сделать копию списка избранных персонажей, чтобы не изменять
    /// оригинальный список в состоянии CharactersState.
    final list = List<Character>.from(state.favorites);

    switch (_sort) {
      case FavoritesSort.name:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case FavoritesSort.status:
        list.sort((a, b) => a.status.compareTo(b.status));
        break;
      case FavoritesSort.species:
        list.sort((a, b) => a.species.compareTo(b.species));
        break;
    }

    return list;
  }

  /// Изменилось состояние CharactersState, нужно обновить список избранных персонажей.
  void _onStateChanged(CharactersState state) {
    final newList = _buildSortedList(state);

    for (int i = _favorites.length - 1; i >= 0; i--) {
      final oldItem = _favorites[i];

      if (!newList.any((c) => c.id == oldItem.id)) {
        final removedItem = _favorites.removeAt(i);

        _listKey.currentState?.removeItem(
          i,
              (context, animation) => _buildRemovedItem(
            removedItem,
            animation,
          ),
          duration: const Duration(milliseconds: 400),
        );
      }
    }

    _favorites = newList;
  }

  Widget _buildRemovedItem(
      Character character,
      Animation<double> animation,
      ) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: CharacterCard(character: character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _sort = context.watch<FavoritesSortCubit>().state;
    return
      BlocListener<CharactersBloc, CharactersState>(
        listener: (context, state) {
          if(state.isLoading) return; // Игнорируем изменения во время загрузки
          if(state.error != null) return; // Игнорируем изменения при ошибке
          setState(() {
            //_sort = sort;
            _onStateChanged(state);
          });

        },
        child: BlocBuilder<CharactersBloc, CharactersState>(
          builder: (context, state) {
            _favorites = _buildSortedList(state);
            return _favorites.isEmpty
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_border, size: 64),
                  SizedBox(height: 12),
                  Text('Нет избранных персонажей'),
                ],
              ),
            )
                : AnimatedList(
              key: _listKey,
              initialItemCount: _favorites.length,
              itemBuilder: (context, index, animation) {
                final character = _favorites[index];
            
                return SizeTransition(
                  sizeFactor: animation,
                  child: CharacterCard(
                    character: character,
                  ),
                );
              },
            );
          }
        ),
    );
  }
}