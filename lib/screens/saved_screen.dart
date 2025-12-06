import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yts_movie_browser/screens/about_app_screen.dart';
import '../models/enum/enum_message_type.dart';
import '../providers/movie_provider.dart';
import '../services/snackbar_service.dart';
import '../widgets/yts_movie_card.dart';
import 'movie_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int? _activeMovieId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Saved"),
        actions: [
          //3dot action menu with about the app page linked.
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutAppScreen()),
              );
            },
          ),
        ],
      ),
      body: provider.savedMovies.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No saved movies yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: provider.savedMovies.length,
              itemBuilder: (context, index) {
                final movie = provider.savedMovies[index];
                final isSelected = _activeMovieId == movie.id;
                final isSaved = provider.isMovieSaved(movie.id);

                return YtsMovieCard(
                  movie: movie,
                  isSelected: isSelected,
                  savedIcon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                  savedColor: isSaved ? colors.tertiary : Colors.white,
                  onCardTap: () {
                    setState(() {
                      _activeMovieId = isSelected ? null : movie.id;
                    });
                  },
                  onDetailsTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailScreen(initialMovie: movie),
                      ),
                    );
                  },
                  onSaveTap: () {
                    provider.toggleSave(movie);
                    if (!isSaved) {
                      SnackbarService.show(
                        context,
                        'Added to Wishlist',
                        type: MessageType.success,
                      );
                    } else {
                      SnackbarService.show(
                        context,
                        'Removed from Wishlist',
                        type: MessageType.success,
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
