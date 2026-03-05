import 'package:flutter_bloc/flutter_bloc.dart';
import '../favorites_screen.dart';

class FavoritesSortCubit extends Cubit<FavoritesSort> {
  FavoritesSortCubit() : super(FavoritesSort.name);

  void changeSort(FavoritesSort sort) {
    emit(sort);
  }
}