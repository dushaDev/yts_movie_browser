import 'package:dio/dio.dart';
import '../constants.dart';
import '../models/movie.dart';

class ApiService {
  final Dio _dio = Dio();

  // --- HELPER: Generic Fetcher ---
  // Reduces code duplication by handling the try-catch and JSON parsing in one place
  Future<List<Movie>> _fetchMoviesFromUrl(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}$endpoint',
        queryParameters: params,
      );

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        final data = response.data['data'];

        // Handle "list_movies" response structure
        if (data.containsKey('movies')) {
          final List moviesJson = data['movies'];
          return moviesJson.map((json) => Movie.fromJson(json)).toList();
        }
        // Handle "list_upcoming" response structure (sometimes it's just 'upcoming_movies')
        else if (data.containsKey('upcoming_movies')) {
          final List moviesJson = data['upcoming_movies'];
          return moviesJson.map((json) => Movie.fromJson(json)).toList();
        }

        return []; // Return empty if no movies found (e.g., page 500)
      } else {
        throw Exception('API responded with error: ${response.statusMessage}');
      }
    } catch (e) {
      // You can add better error logging here
      print("API Error: $e");
      rethrow;
    }
  }

  // --- 1. POPULAR MOVIES (Horizontal List) ---
  // Sorted by download count to show what's trending
  Future<List<Movie>> getPopularMovies() async {
    return _fetchMoviesFromUrl(
      AppConstants.listMoviesEndpoint,
      params: {
        'limit': 10, // Get top 10
        'sort_by': 'download_count', // The YTS "Popular" filter
        'order_by': 'desc',
      },
    );
  }

  // --- 3. LATEST MOVIES / SEARCH / FILTER (Main Grid) ---
  // This is the main workhorse function.
  // It handles pagination, search queries, and filters all in one.
  Future<List<Movie>> getMovies({
    int page = 1,
    String? query,
    String? quality, // '720p', '1080p', '3D'
    String? genre, // 'Action', 'Comedy'
    int? rating, // 0-9
    String sortBy = 'date_added', // Default: Latest
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': 20, // Standard page size
      'sort_by': sortBy,
      'order_by': 'desc',
    };

    // Only add these params if they are provided (not null/empty)
    if (query != null && query.isNotEmpty) {
      params['query_term'] = query;
    }

    if (quality != null && quality != 'All') {
      params['quality'] = quality;
    }

    if (genre != null && genre != 'All') {
      params['genre'] = genre;
    }

    if (rating != null && rating > 0) {
      params['minimum_rating'] = rating;
    }

    return _fetchMoviesFromUrl(AppConstants.listMoviesEndpoint, params: params);
  }

  // --- 4. MOVIE SUGGESTIONS ---
  // Used on the Detail Screen for "You might also like"
  Future<List<Movie>> getSuggestions(int movieId) async {
    return _fetchMoviesFromUrl(
      AppConstants.movieSuggestionsEndpoint,
      params: {'movie_id': movieId},
    );
  }
}
