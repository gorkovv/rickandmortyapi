import '../../domain/entities/character.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';

class CharacterRepositoryImpl  {
  final RemoteDataSource remote;
  final LocalDataSource local;

  CharacterRepositoryImpl(this.remote, this.local);

  /// Персонажи загружаются постранично.
  Future<List<Character>> getCharacters(int page) async {
    try {
      // Получить данные из сети
      final remoteModels = await remote.fetchCharacters(page);

      // Кешировать страницу
      await local.cachePage(page, remoteModels);

      // вернуть список персонажей
      return remoteModels.map((e) => e.toEntity()).toList();
    } catch (e) {
      // Если сеть упала — взять данные из кеша
      final cached = local.getCachedPage(page);

      if (cached != null && cached.isNotEmpty) {
        return cached.map((e) => e.toEntity()).toList();
      }

      //Если кеша нет
      rethrow;
    }
  }

  /// Персонажи, которые пользователь отметил как избранные,
  /// хранятся только локально. Поэтому при загрузке страницы мы всегда
  /// запрашиваем их из кеша, а при переключении статуса — сохраняем изменения в кеш.
  Future<List<Character>> getFavorites() async {
    final models = local.getFavorites();
    return models.map((e) => e.toEntity()).toList();
  }

  Future<void> toggleFavorite(Character character) async {
    final current = local.getFavorites();

    final exists =
    current.any((element) => element.id == character.id);

    if (exists) {
      current.removeWhere((e) => e.id == character.id);
    } else {
      current.add(Character(
        id: character.id,
        name: character.name,
        image: character.image,
        status: character.status,
        species: character.species,
      ));
    }

    await local.saveFavorites(current);
  }

  Future<bool> isFavorite(int id) async {
    final current = local.getFavorites();
    return current.any((e) => e.id == id);
  }
}