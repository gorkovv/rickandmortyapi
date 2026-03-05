import 'package:flutter/material.dart';

/// Класс для управления темами приложения
/// Сделаю немного настроек для тестового задания, чтобы было видно,
/// что темы действительно разные
class AppTheme {
  AppTheme._(); // Приватный конструктор для предотвращения создания экземпляров

  /// Светлая тема конфигурация
  static ThemeData get lightTheme => themeLight();

  /// Темная тема конфигурация
  static ThemeData get darkTheme => themeDark();



  static ThemeData themeLight() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: _lightAppBarTheme,
      bottomNavigationBarTheme:  BottomNavigationBarThemeData(
        backgroundColor: Colors.green[100],
        selectedItemColor: Colors.amber[900],
        selectedIconTheme:  IconThemeData(color: Colors.amber[900]),
        selectedLabelStyle:  TextStyle(
            color: Colors.amber[900],
            fontWeight: FontWeight.bold
        ),
        unselectedItemColor: Colors.green[800],
      ),
    );
  }

  static ThemeData themeDark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey[800],
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: _darkAppBarTheme,
      bottomNavigationBarTheme:  BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF013205),
        selectedItemColor: Colors.amber[900],
        selectedIconTheme:  IconThemeData(color: Colors.amber[900]),
        selectedLabelStyle:  TextStyle(
            color: Colors.amber[900],
            fontWeight: FontWeight.bold
        ),
        unselectedItemColor: Colors.green[100],
      ),
    );
  }

  ///  App bar theme для светлой темы
  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    backgroundColor: Colors.green[100],
    iconTheme:  IconThemeData(color: Color(0xFF013205)),
     titleTextStyle: TextStyle(
      color: Color(0xFF013205),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );

  /// App bar theme для темной темы
  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    backgroundColor: Color(0xFF013205),
    iconTheme:  IconThemeData(color: Colors.green[100]),
    titleTextStyle: TextStyle(
      color: Colors.green[100],
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),

  );

}
