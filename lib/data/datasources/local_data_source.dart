import 'package:hive/hive.dart';

import '../../domain/entities/character.dart';

class LocalDataSource {
  final Box cacheBox = Hive.box('characters_cache');
  final Box favoritesBox = Hive.box('favorites');

  Future<void> cachePage(int page, List<Character> characters) async {
    cacheBox.put(page, characters.map((e) => e.toJson()).toList());
  }

  List<Character>? getCachedPage(int page) {
    final data = cacheBox.get(page);
    if (data == null) return null;

    return (data as List)
        .map((e) => Character.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveFavorites(List<Character> models) async {
    await favoritesBox.put(
      'items',
      models.map((e) => e.toJson()).toList(),
    );
  }

  List<Character> getFavorites() {
    final data = favoritesBox.get('items', defaultValue: []);

    return (data as List)
        .map((e) => Character.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
