import 'package:equatable/equatable.dart';

import '../../../domain/entities/character.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharactersEvent {}

class LoadMoreCharacters extends CharactersEvent {}

class ToggleFavorite extends CharactersEvent {
  final Character character;

  const ToggleFavorite(this.character);

  @override
  List<Object?> get props => [character];
}