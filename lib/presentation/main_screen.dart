import 'package:flutter/material.dart';
import 'characters/characters_screen.dart';
import 'favorites/favorites_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _pages = const [
    CharactersScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentScreen = _pages[_currentIndex] as AppBarScreen;
    return Scaffold(
      appBar: currentScreen.buildAppBar(context),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Персонажи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Избранное',
          ),
        ],
      ),
    );
  }

}

/// Интерфейс для экранов, которые должны предоставлять AppBar
abstract class AppBarScreen extends Widget {
  const AppBarScreen({super.key});

  PreferredSizeWidget buildAppBar(BuildContext context);
}