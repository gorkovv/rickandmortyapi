
import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';

class CharactersState extends Equatable {
  final List<Character> characters; // Все загруженные персонажи
  final List<Character> favorites; // Список избранных персонажей
  final bool isLoading;
  final bool hasReachedMax; // Флаг, указывающий, что достигнут конец списка (нет больше страниц для загрузки)
  final String? error;

  const CharactersState({
    this.characters = const [],
    this.favorites = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.error,
  });

  CharactersState copyWith({
    List<Character>? characters,
    List<Character>? favorites,
    bool? isLoading,
    bool? hasReachedMax,
    String? error,
  }) {
    return CharactersState(
      characters: characters ?? this.characters,
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [characters, favorites, isLoading, hasReachedMax, error];
}