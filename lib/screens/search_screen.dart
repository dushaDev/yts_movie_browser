import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yts_movie_browser/widgets/shimmer_loading.dart';
import '../providers/movie_provider.dart';
import '../services/snackbar_service.dart';
import '../widgets/yts_movie_card.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 1. NEW: Track which movie card is currently active (showing overlay)
  int? _activeMovieId;

  // Local state for filters
  String? _selectedGenre;
  String? _selectedQuality;
  int? _selectedRating;

  final List<String> _genres = [
    'Action',
    'Comedy',
    'Sci-Fi',
    'Horror',
    'Romance',
    'Thriller',
    'Animation',
  ];
  final List<String> _qualities = ['720p', '1080p', '2160p', '3D'];

  void _performSearch() {
    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() {
      _activeMovieId = null; // Reset selection on new search
    });

    Provider.of<MovieProvider>(context, listen: false).searchMovies(
      query: _searchController.text,
      genre: _selectedGenre,
      quality: _selectedQuality,
      rating: _selectedRating,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    final theme = Theme.of(context);
    ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        centerTitle: false,
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: "Search like \"Batman\"...",
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _performSearch(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: colors.primary, size: 28),
            onPressed: _performSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, size: 28),
            onPressed: () => _showFilterBottomSheet(colors, context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Filters Row
          if (_selectedGenre != null ||
              _selectedQuality != null ||
              _selectedRating != null)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedGenre != null)
                    _buildFilterChip("Genre: $_selectedGenre"),
                  if (_selectedQuality != null)
                    _buildFilterChip("Quality: $_selectedQuality"),
                  if (_selectedRating != null)
                    _buildFilterChip("Rating: $_selectedRating+"),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedGenre = null;
                        _selectedQuality = null;
                        _selectedRating = null;
                      });
                      _performSearch();
                    },
                    child: const Text("Clear All"),
                  ),
                ],
              ),
            ),

          // 2. WRAP EXPANDED IN GESTURE DETECTOR
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Click background to close overlay AND hide keyboard
                setState(() {
                  _activeMovieId = null;
                });
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque, // Catch clicks on empty space
              child: provider.isSearchLoading
                  ? const LatestShimmer()
                  : provider.searchError.isNotEmpty
                  ? Center(
                      child: Text(
                        provider.searchError,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : provider.searchResults.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: provider.searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = provider.searchResults[index];

                        // 3. CHECK SELECTION STATE
                        final isSelected = _activeMovieId == movie.id;
                        final isSaved = provider.isMovieSaved(movie.id);

                        return YtsMovieCard(
                          movie: movie,
                          isSelected: isSelected,
                          savedIcon: isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          savedColor: isSaved ? colors.tertiary : Colors.white,

                          // 4. NAVIGATION ACTION
                          onCardTap: () {
                            setState(() {
                              _activeMovieId = isSelected ? null : movie.id;
                            });
                            FocusScope.of(
                              context,
                            ).unfocus(); // Also hide keyboard
                          },

                          // 5. NAVIGATION ACTION
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
                            // Navigate to Details Screen (Code coming soon)
                            provider.toggleSave(movie);
                            SnackbarService.show(context, 'Added to Wishlist');
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.movie_creation_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Search for movies to begin",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primaryContainer.withAlpha(150),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  void _showFilterBottomSheet(ColorScheme colors, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter Results",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Genre",
                    style: TextStyle(color: colors.onSurface.withAlpha(160)),
                  ),
                  Wrap(
                    spacing: 8,
                    children: _genres.map((genre) {
                      return ChoiceChip(
                        label: Text(genre),
                        selected: _selectedGenre == genre,
                        onSelected: (selected) {
                          setModalState(
                            () => _selectedGenre = selected ? genre : null,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),

                  Text(
                    "Quality",
                    style: TextStyle(color: colors.onSurface.withAlpha(160)),
                  ),
                  Wrap(
                    spacing: 8,
                    children: _qualities.map((q) {
                      return ChoiceChip(
                        label: Text(q),
                        selected: _selectedQuality == q,
                        onSelected: (selected) {
                          setModalState(
                            () => _selectedQuality = selected ? q : null,
                          );
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                        _performSearch();
                      },
                      child: const Text("Apply Filters"),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
