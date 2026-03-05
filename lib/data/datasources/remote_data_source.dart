import 'package:dio/dio.dart';

import '../../domain/entities/character.dart';

class RemoteDataSource {
  final Dio dio;

  RemoteDataSource(this.dio);

  Future<List<Character>> fetchCharacters(int page) async {
    final response = await dio.get('character', queryParameters: {
      'page': page,
    });

    final results = response.data['results'] as List;

    return results
        .map((e) => Character.fromJson(e))
        .toList();
  }
}