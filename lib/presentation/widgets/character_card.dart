import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/character.dart';
import '../characters/bloc/characters_bloc.dart';
import '../characters/bloc/characters_state.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({
    super.key,
    required this.character,
  });

  /// Получить строку для отображения статуса (например, "Alive", "Dead", "Unknown")
  /// TODO Расширить для поддержки других языков или статусов
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return 'Живой';
      case 'dead':
        return 'Мёртвый';
      default: // Unknown
        return 'Неизвестно';
    }
  }

  /// Получить строку для отображения вида персонажа (например, "Human", "Alien" и т.д.)
  /// TODO Расширить для поддержки других языков или видов
  String _getSpeciesText(String species) {
    switch (species.toLowerCase()) {
      case 'human':
        return 'Человек';
      case 'alien':
        return 'Инопланетянин';
      case 'mythological creature':
        return 'Мифическое Cущество';
        case 'poopybutthole':
        return 'Какашка';
        case 'robot':
        return 'Робот';
        case 'cronenberg':
        return 'Кроненберг';
        case 'humanoid':
        return 'Гуманоид';
        case 'disease':
        return 'Болезнь';
        case 'animal':
        return 'Животное';
      default:
        return species; // Оставляем как есть, если вид неизвестен
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      buildWhen: (previous, current) =>
         previous.favorites != current.favorites,
      builder: (context, state) {
        final isFavorite =
        state.favorites.any((e) => e.id == character.id);

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Переход к деталям персонажа где можно будет увидеть более подробную информацию и добавить в избранное
              // TODO Реализовать экран деталей персонажа и навигацию к нему
              // Navigator.push(context, MaterialPageRoute(builder: (_) => CharacterDetailsScreen(character: character
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  /// Hero для плавного перехода к фаворитам и деталям персонажа
                  Hero(
                    tag: 'character_${character.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        character.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            width: 80,
                            height: 80,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (_, _, _) =>
                        const Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// Информация о персонаже (имя, вид, статус)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSpeciesText(character.species),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _StatusIndicator(status: character.status),
                            const SizedBox(width: 6),
                            Text(
                              _getStatusText(character.status),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ⭐ Кнопка избранного
                  IconButton(
                    onPressed: () {
                      context
                          .read<CharactersBloc>()
                          .toggleFavorite(character);
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: isFavorite
                          ? const Icon(
                        Icons.star,
                        key: ValueKey(true),
                        color: Colors.amber,
                      )
                          : const Icon(
                        Icons.star_border,
                        key: ValueKey(false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String status;

  const _StatusIndicator({required this.status});

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: _getColor(),
        shape: BoxShape.circle,
      ),
    );
  }
}