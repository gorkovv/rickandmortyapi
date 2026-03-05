import 'package:bloc/bloc.dart';
import '../../../data/repositories/character_repository_impl.dart';
import '../../../domain/entities/character.dart';
import 'characters_event.dart';
import 'characters_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharacterRepositoryImpl repository;

  int _currentPage = 1;
  bool _isFetching = false;

  CharactersBloc(this.repository) : super(const CharactersState()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  /// Загрузка начального списка персонажей при открытии экрана.
  Future<void> _onLoadCharacters(
      LoadCharacters event,
      Emitter<CharactersState> emit,
      ) async {
    _currentPage = 1;

    /// Сброс состояния при загрузке новых данных
    emit(state.copyWith(
      isLoading: true,
      characters: [],
      hasReachedMax: false,
      error: null,
    ));

    try {
      final characters = await repository.getCharacters(_currentPage);
      final favorites = await repository.getFavorites();

      /// Обновляем состояние с новыми данными и списком избранных
      emit(state.copyWith(
        characters: characters,
        favorites: favorites,
        isLoading: false,
        hasReachedMax: characters.isEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки персонажей: ${e.toString()}',
      ));
    }
  }

  /// Пагинация: загрузка следующей страницы при достижении конца списка.
  Future<void> _onLoadMoreCharacters(
      LoadMoreCharacters event,
      Emitter<CharactersState> emit,
      ) async {
    if (state.hasReachedMax || _isFetching) return;

    _isFetching = true;
    _currentPage++;

    try {
      final newCharacters =
      await repository.getCharacters(_currentPage);

      if (newCharacters.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
          characters: List.of(state.characters)
            ..addAll(newCharacters),
        ));
      }
    } catch (_) {
      _currentPage--; // rollback page
    }

    _isFetching = false;
  }

  /// Переключение статуса избранного для персонажа.
  /// После изменения статуса мы запросить обновленный список
  /// избранных и обновить состояние.
  Future<void> _onToggleFavorite(
      ToggleFavorite event,
      Emitter<CharactersState> emit,
      ) async {
    await repository.toggleFavorite(event.character);

    final updatedFavorites = await repository.getFavorites();

    emit(state.copyWith(favorites: updatedFavorites));
  }


  bool isFavorite(int id) => state.favorites.any((e) => e.id == id);

  void toggleFavorite(Character character) {
    add(ToggleFavorite(character));
  }
}