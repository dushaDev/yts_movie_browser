import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:startapp_sdk/startapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yts_movie_browser/models/enum/enum_message_type.dart';
import 'package:yts_movie_browser/screens/wrappers/connection_wrapper.dart';
import 'package:yts_movie_browser/widgets/error_feedback.dart';
import '../models/movie.dart';
import '../models/movie_details_models.dart';
import '../providers/movie_provider.dart';
import '../services/api_service.dart';
import '../services/snackbar_service.dart';
import '../widgets/yts_movie_card.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie initialMovie;

  const MovieDetailScreen({super.key, required this.initialMovie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Movie> _fullMovieFuture;
  late Future<List<Movie>> _suggestionsFuture;
  late ScrollController _scrollController;
  var startAppSdk = StartAppSdk();
  StartAppBannerAd? topBannerAd;
  StartAppBannerAd? bottomBannerAd;

  // 2. Variable to track the state
  bool _isSliverAppBarExpanded = false;

  // Define the height of the expanded area
  final double _expandedHeight = 450.0;

  @override
  void initState() {
    super.initState();
    _fullMovieFuture = _apiService.getMovieDetail(widget.initialMovie.id);
    _suggestionsFuture = _apiService.getSuggestions(widget.initialMovie.id);

    _scrollController = ScrollController();

    // 3. Add the listener
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        // Calculate if the app bar is collapsed
        // kToolbarHeight is usually 56.0
        bool isCollapsed =
            _scrollController.offset > (_expandedHeight - kToolbarHeight);

        // Only call setState if the status changes to avoid unnecessary rebuilds
        if (isCollapsed != _isSliverAppBarExpanded) {
          setState(() {
            _isSliverAppBarExpanded = isCollapsed;
          });
        }
      }
    });

    // TODO make sure to comment out this line before release
    // startAppSdk.setTestAdsEnabled(true);

    // TODO use one of the following types: BANNER, MREC, COVER
    startAppSdk
        .loadBannerAd(StartAppBannerType.BANNER)
        .then((bannerAd) {
          setState(() {
            topBannerAd = bannerAd;
          });
        })
        .onError<StartAppException>((ex, stackTrace) {
          debugPrint("Error loading Banner ad: ${ex.message}");
        })
        .onError((error, stackTrace) {
          debugPrint("Error loading Banner ad: $error");
        });

    // TODO use one of the following types: BANNER, MREC, COVER
    startAppSdk
        .loadBannerAd(StartAppBannerType.MREC)
        .then((bannerAd) {
          setState(() {
            bottomBannerAd = bannerAd;
          });
        })
        .onError<StartAppException>((ex, stackTrace) {
          debugPrint("Error loading Banner ad: ${ex.message}");
        })
        .onError((error, stackTrace) {
          debugPrint("Error loading Banner ad: $error");
        });
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        SnackbarService.show(
          context,
          "Could not open link.",
          type: MessageType.info,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    topBannerAd = null;
    bottomBannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<MovieProvider>(context);
    return ConnectionWrapper(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _fullMovieFuture = _apiService.getMovieDetail(
                widget.initialMovie.id,
              );
              _suggestionsFuture = _apiService.getSuggestions(
                widget.initialMovie.id,
              );
            });
          },
          child: FutureBuilder<Movie>(
            future: _fullMovieFuture,
            initialData: widget.initialMovie,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return NoInternetWidget(
                  onRetry: () {
                    setState(() {
                      _fullMovieFuture = _apiService.getMovieDetail(
                        widget.initialMovie.id,
                      );
                      _suggestionsFuture = _apiService.getSuggestions(
                        widget.initialMovie.id,
                      );
                    });
                  },
                );
              }
              final movie = snapshot.data!;
              final isFullLoaded =
                  snapshot.connectionState == ConnectionState.done;
              final isSaved = provider.isMovieSaved(movie.id);
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // 1. HERO HEADER
                  SliverAppBar(
                    backgroundColor: colors.surfaceBright,
                    title: _isSliverAppBarExpanded
                        ? AnimatedOpacity(
                            duration: const Duration(milliseconds: 800),
                            opacity: _isSliverAppBarExpanded ? 1.0 : 0.0,
                            child: Text(
                              movie.title,
                              style: textTheme.headlineMedium?.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                              ),
                            ),
                          )
                        : null,
                    expandedHeight: _expandedHeight,
                    pinned: true,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: CachedNetworkImage(
                              imageUrl:
                                  movie.backgroundImage ??
                                  movie.mediumCoverImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(color: Colors.black.withAlpha(60)),
                          Center(
                            child: Container(
                              width: 200,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: movie.mediumCoverImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            right: 15,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white38,
                              child: IconButton(
                                onPressed: () {
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
                                icon: Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: isSaved
                                      ? colors.tertiary
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. CONTENT
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TITLE & META
                          Center(
                            child: Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildInfoChip(colors, "${movie.year}"),
                              movie.mpaRating == ''
                                  ? Container()
                                  : const SizedBox(width: 8),
                              movie.mpaRating == ''
                                  ? Container()
                                  : _buildInfoChip(
                                      colors,
                                      movie.mpaRating?.toUpperCase() ?? "NR",
                                    ),
                              if (movie.runtime != null &&
                                  movie.runtime! > 0) ...[
                                const SizedBox(width: 8),
                                _buildInfoChip(colors, "${movie.runtime} min"),
                              ],
                              const SizedBox(width: 12),
                              Icon(
                                Icons.star,
                                size: 20,
                                color: colors.tertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${movie.rating}",
                                style: TextStyle(
                                  color: colors.tertiary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // GENRES
                          Center(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: movie.genres
                                  .map(
                                    (g) => Chip(
                                      label: Text(g),
                                      backgroundColor:
                                          colors.surfaceContainerHighest,
                                      labelStyle: TextStyle(
                                        fontSize: 12,
                                        color: colors.primary,
                                      ),
                                      side: BorderSide.none,
                                      padding: EdgeInsets.zero,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // TRAILER
                          if (movie.ytTrailerCode != null)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _launchURL(
                                  "https://www.youtube.com/watch?v=${movie.ytTrailerCode}",
                                ),
                                icon: Icon(
                                  Icons.play_circle_fill,
                                  color: colors.onError,
                                ),
                                label: const Text("Watch Trailer"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[900],
                                  foregroundColor: colors.onError,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 30),
                          Divider(color: colors.surfaceContainerHighest),
                          const SizedBox(height: 20),

                          // PLOT
                          _buildSectionTitle(colors, textTheme, "Plot Summary"),
                          const SizedBox(height: 8),
                          Text(
                            movie.descriptionFull?.isNotEmpty == true
                                ? movie.descriptionFull!
                                : movie.summary,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: colors.onSurface.withAlpha(200),
                              height: 1.6,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 15),
                          // TOP BANNER
                          topBannerAd != null
                              ? SizedBox(
                                  height: 50, // Standard Banner Height
                                  width: 320, // Standard Banner Width
                                  child: StartAppBanner(topBannerAd!),
                                )
                              : Container(),
                          const SizedBox(height: 15),

                          // CAST
                          if (isFullLoaded &&
                              movie.cast != null &&
                              movie.cast!.isNotEmpty) ...[
                            _buildSectionTitle(colors, textTheme, "Top Cast"),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: movie.cast!.length,
                                itemBuilder: (_, index) =>
                                    _buildCastCard(colors, movie.cast![index]),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],

                          // SCREENSHOTS
                          if (isFullLoaded &&
                              (movie.largeScreenshot1 != null)) ...[
                            _buildSectionTitle(colors, textTheme, "Images"),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 140,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  if (movie.largeScreenshot1 != null)
                                    _buildScreenshot(movie.largeScreenshot1!),
                                  if (movie.largeScreenshot2 != null)
                                    _buildScreenshot(movie.largeScreenshot2!),
                                  if (movie.largeScreenshot3 != null)
                                    _buildScreenshot(movie.largeScreenshot3!),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],

                          // --- UPDATED: DOWNLOAD OPTIONS ---
                          if (isFullLoaded && movie.torrents != null) ...[
                            _buildSectionTitle(
                              colors,
                              textTheme,
                              "Select Quality",
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: movie.torrents!
                                  .map((t) => _buildDownloadRow(colors, t))
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                          ],
                          bottomBannerAd != null
                              ? SizedBox(
                                  height: 250, // Standard Banner Height
                                  width: 300, // Standard Banner Width
                                  child: StartAppBanner(bottomBannerAd!),
                                )
                              : Container(),
                          const SizedBox(height: 15),

                          // SUGGESTIONS
                          _buildSectionTitle(
                            colors,
                            textTheme,
                            "You might also like",
                          ),
                          const SizedBox(height: 10),
                          _buildSuggestionsList(
                            movie: movie,
                            provider: provider,
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionTitle(
    ColorScheme colors,
    TextTheme textTheme,
    String title,
  ) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colors.onSurface,
      ),
    );
  }

  Widget _buildInfoChip(ColorScheme colors, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: colors.onSurfaceVariant),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colors.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCastCard(ColorScheme colors, Cast actor) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[800],
            backgroundImage: actor.urlSmallImage.isNotEmpty
                ? NetworkImage(actor.urlSmallImage)
                : null,
            child: actor.urlSmallImage.isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onSurface.withAlpha(200),
              fontSize: 11,
            ),
          ),
          Text(
            actor.characterName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onSurface.withAlpha(110),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshot(String url) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (_, __) =>
              Container(color: Colors.grey[900], width: 200),
        ),
      ),
    );
  }

  // --- NEW: DOWNLOAD ROW WITH 2 BUTTONS ---
  Widget _buildDownloadRow(ColorScheme colors, Torrent t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: colors.onSurface.withAlpha(12),
        border: Border.all(color: colors.onSurface.withAlpha(50)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 1. Quality Badge (720p / 1080p)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: t.quality == '1080p'
                  ? Colors.green
                  : (t.quality == '720p' ? Colors.blue : Colors.purple),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              t.quality,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: colors.surface,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 2. Info (Type + Size)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.type.toUpperCase(),
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${t.size} • ${t.seeds} seeds",
                  style: TextStyle(
                    color: colors.onSurface.withAlpha(160),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // 3. Torrent File Button
          IconButton(
            onPressed: () => _launchURL(t.url),
            icon: const Icon(Icons.file_download_outlined),
            color: colors.onSurface.withAlpha(200),
            tooltip: "Download Torrent File",
          ),

          // 4. Magnet Link Button
          IconButton(
            onPressed: () {
              final magnet =
                  "magnet:?xt=urn:btih:${t.hash}&dn=${Uri.encodeComponent(widget.initialMovie.title)}";
              _launchURL(magnet);
            },
            icon: SizedBox(
              width: 28,
              height: 28,
              child: Image.asset('assets/images/magnetism.png'),
            ),
            color: colors.primary,
            tooltip: "Open Magnet Link",
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList({
    required Movie movie,
    required MovieProvider provider,
    required ColorScheme colors,
  }) {
    return FutureBuilder<List<Movie>>(
      future: _suggestionsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final isSaved = provider.isMovieSaved(movie.id);
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                margin: const EdgeInsets.only(right: 10),
                child: YtsMovieCard(
                  movie: snapshot.data![index],
                  savedIcon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                  savedColor: isSaved ? colors.tertiary : Colors.white,
                  isSelected: false,
                  onSaveTap: () {
                    provider.toggleSave(snapshot.data![index]);
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
                  onCardTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(
                        initialMovie: snapshot.data![index],
                      ),
                    ),
                  ),
                  onDetailsTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(
                        initialMovie: snapshot.data![index],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
