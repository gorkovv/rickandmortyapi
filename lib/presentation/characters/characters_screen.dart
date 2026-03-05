import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../main_screen.dart';
import '../theme_cubit.dart';
import 'bloc/characters_bloc.dart';
import 'bloc/characters_event.dart';
import 'bloc/characters_state.dart';
import '../widgets/character_card.dart';

class CharactersScreen extends StatefulWidget implements AppBarScreen{
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    /// Слушаем изменения темы, чтобы обновлять иконку в AppBar
    final themeMode = context.watch<ThemeCubit>().state;

    return AppBar(
      title: Row(
            children: [
              Icon(Icons.people),
              const SizedBox(width: 8),
              Text('Персонажи'),
            ],
          ),
      actions: [
        IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              key: ValueKey(themeMode),
            ),
          ),
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),
      ],
    );
  }
}

class _CharactersScreenState extends State<CharactersScreen> {
  late final ScrollController _scrollController;
  CharactersBloc get _bloc => context.read<CharactersBloc>();


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_bloc.state.hasReachedMax) return;

    final threshold = 100.0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - threshold) {
      _bloc.add(LoadMoreCharacters());
    }
  }

  Future<void> _onRefresh() async {
    _bloc.add(LoadCharacters());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        if (state.isLoading && state.characters.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.error != null && state.characters.isEmpty) {
          return _ErrorView(
            message: state.error!,
            onRetry: () {
              context
                  .read<CharactersBloc>()
                  .add(LoadCharacters());
            },
          );
        }

        if (state.characters.isEmpty) {
          return const Center(
            child: Text('Нет персонажей для отображения.'),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.characters.length
                : state.characters.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.characters.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final character = state.characters[index];

              return CharacterCard(
                character: character,
              );
            },
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}