import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/local_db_service.dart';

class MovieProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalDbService _dbService = LocalDbService();

  // --- 1. STATE VARIABLES ---

  // Section: Popular (Horizontal List)
  List<Movie> _popularMovies = [];
  bool _isPopularLoading = false;

  List<Movie> _savedMovies = [];
  List<Movie> get savedMovies => _savedMovies;
  // A Set is faster for checking "is this movie saved?" inside a list
  final Set<int> _savedMovieIds = {};
  // Section: Latest / Main Grid (Vertical Infinite Scroll)
  List<Movie> _movies = [];
  bool _isLoading = false;
  int _currentPage = 1;

  List<Movie> _searchResults = [];
  bool _isSearchLoading = false;
  String _searchError = '';

  List<Movie> get searchResults => _searchResults;
  bool get isSearchLoading => _isSearchLoading;
  String get searchError => _searchError;

  // Errors
  String _errorMessage = '';

  // --- 2. GETTERS ---
  List<Movie> get popularMovies => _popularMovies;
  bool get isPopularLoading => _isPopularLoading;

  List<Movie> get movies => _movies; // This is the main grid
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // --- 3. FETCH FUNCTIONS ---

  // Call this once when App Starts
  Future<void> loadHomePageData() async {
    _errorMessage = '';
    // Fetch both sections in parallel for speed
    await Future.wait([fetchPopularMovies(), getMovies(reset: true)]);
  }

  Future<void> fetchPopularMovies() async {
    _isPopularLoading = true;
    notifyListeners();
    try {
      _popularMovies = await _apiService.getPopularMovies();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isPopularLoading = false;
      notifyListeners();
    }
  }

  // Used for Initial Load AND Infinite Scroll
  Future<void> getMovies({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _movies = [];
      _isLoading = true; // Show full spinner on reset
      _errorMessage = ''; // Clear error on reset
      notifyListeners();
    }

    try {
      final newMovies = await _apiService.getMovies(page: _currentPage);

      if (newMovies.isNotEmpty) {
        _movies.addAll(newMovies);
        _currentPage++;
        _errorMessage = ''; // Clear error on reset
      }
    } catch (e) {
      // IF this is the first page, we need to show the Full Screen Error
      if (_movies.isEmpty) {
        _errorMessage = "No Connection";
      }
      // IF we already have movies (pagination), we throw it so UI can show Snackbar
      else {
        throw Exception("Could not load more movies");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- SEARCH FUNCTION ---
  Future<void> searchMovies({
    String query = '',
    String? genre,
    String? quality,
    int? rating,
  }) async {
    _isSearchLoading = true;
    _searchError = '';
    _searchResults = []; // Clear previous results
    notifyListeners();

    try {
      // Reuse the generic getMovies API but with specific params
      _searchResults = await _apiService.getMovies(
        page: 1, // Always start fresh
        query: query,
        genre: genre,
        quality: quality,
        rating: rating,
      );

      if (_searchResults.isEmpty) {
        _searchError = "No movies found.";
      }
    } catch (e) {
      _searchError = "Search failed. Please try again.";
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  // Helper to clear results when leaving screen
  void clearSearch() {
    _searchResults = [];
    _searchError = '';
    notifyListeners();
  }

  // 1. Load saved movies (Call this on App Start)
  Future<void> loadSavedMovies() async {
    _savedMovies = await _dbService.getSavedMovies();
    // Update the ID set for fast lookups
    _savedMovieIds.clear();
    for (var movie in _savedMovies) {
      _savedMovieIds.add(movie.id);
    }
    notifyListeners();
  }

  // 2. Toggle Save (Add/Remove)
  Future<void> toggleSave(Movie movie) async {
    if (_savedMovieIds.contains(movie.id)) {
      // Already saved -> Remove it
      await _dbService.removeMovie(movie.id);
      _savedMovies.removeWhere((m) => m.id == movie.id);
      _savedMovieIds.remove(movie.id);
    } else {
      // Not saved -> Add it
      await _dbService.saveMovie(movie);
      _savedMovies.add(movie);
      _savedMovieIds.add(movie.id);
    }
    notifyListeners();
  }

  // 3. Helper to check status (Used by UI)
  bool isMovieSaved(int id) {
    return _savedMovieIds.contains(id);
  }
}
