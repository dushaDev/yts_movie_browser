import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/upcoming_movie_card.dart';
import '../widgets/yts_movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _activeMovieId;

  @override
  void initState() {
    super.initState();

    // 1. Setup Scroll Listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // We can look up provider here without issues because it's an event callback
        final provider = Provider.of<MovieProvider>(context, listen: false);
        if (!provider.isLoading) {
          provider.getMovies();
        }
      }
    });

    // 2. THE FIX: Delay the initial load until after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MovieProvider>(context, listen: false);

      // Load ALL data (Popular + Upcoming + Latest)
      if (provider.movies.isEmpty) {
        provider.loadHomePageData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/yts_logo.png',
              height: 25,
              errorBuilder: (_, __, ___) => const Text("YTS Movie Browser"),
            ),
            const SizedBox(width: 8),
            Text('Movie Browser'),
          ],
        ),
        // actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await provider.loadHomePageData();
        },
        child: GestureDetector(
          onTap: () => setState(() => _activeMovieId = null),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // --- SECTION 1: POPULAR HEADER ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: theme.colorScheme.tertiary),
                      const SizedBox(width: 8),
                      Text(
                        "Popular Downloads",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- SECTION 2: POPULAR LIST (Horizontal) ---
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220, // Height for card + title
                  child: provider.isPopularLoading
                      ? const PopularShimmer()
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: provider.popularMovies.length,
                          itemBuilder: (context, index) {
                            final movie = provider.popularMovies[index];
                            // Simple ID check for this horizontal list
                            final isSelected = _activeMovieId == movie.id;

                            return Container(
                              width: 140, // Fixed width for horizontal items
                              margin: const EdgeInsets.only(right: 10),
                              child: YtsMovieCard(
                                movie: movie,
                                isSelected: isSelected,
                                onCardTap: () => setState(
                                  () => _activeMovieId = isSelected
                                      ? null
                                      : movie.id,
                                ),
                                onDetailsTap: () {},
                              ),
                            );
                          },
                        ),
                ),
              ),
              // --- SECTION 3: LATEST HEADER ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 30, 16, 10),
                  child: Text(
                    "Latest Movies",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // --- SECTION 4: MAIN GRID (Vertical) ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final movie = provider.movies[index];
                    final isSelected = _activeMovieId == movie.id;

                    return YtsMovieCard(
                      movie: movie,
                      isSelected: isSelected,
                      onCardTap: () => setState(
                        () => _activeMovieId = isSelected ? null : movie.id,
                      ),
                      onDetailsTap: () {},
                    );
                  }, childCount: provider.movies.length),
                ),
              ),

              // --- SECTION 5: BOTTOM LOADER ---
              SliverToBoxAdapter(
                child: provider.isLoading
                    ? const LatestShimmer()
                    : const SizedBox(height: 80), // Bottom padding
              ),
            ],
          ),
        ),
      ),
    );
  }
}
