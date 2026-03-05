
import 'package:equatable/equatable.dart';

class Character extends Equatable {
final int id;
final String name;
final String image;
final String status; /// Статус персонажа (Alive, Dead, unknown)
final String species; /// Вид персонажа (например, Human, Alien и т.д.)

const Character({
required this.id,
required this.name,
required this.image,
required this.status,
required this.species,
});

@override
List<Object?> get props => [id, name, image, status, species];

  Object? toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'status': status,
      'species': species,
    };
  }

factory Character.fromJson(Map<String, dynamic> json) {
  return Character(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    status: json['status'],
    species: json['species'],
  );
}

Character toEntity() {
  return Character(
    id: id,
    name: name,
    image: image,
    status: status,
    species: species,
  );
}
}