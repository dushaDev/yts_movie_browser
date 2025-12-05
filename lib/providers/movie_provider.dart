import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // --- 1. STATE VARIABLES ---

  // Section: Popular (Horizontal List)
  List<Movie> _popularMovies = [];
  bool _isPopularLoading = false;

  List<Movie> _upcomingMovies = [];
  bool _isUpcomingLoading = false;

  // Section: Latest / Main Grid (Vertical Infinite Scroll)
  List<Movie> _movies = [];
  bool _isLoading = false;
  int _currentPage = 1;

  // Errors
  String _errorMessage = '';

  // --- 2. GETTERS ---
  List<Movie> get popularMovies => _popularMovies;
  bool get isPopularLoading => _isPopularLoading;

  List<Movie> get upcomingMovies => _upcomingMovies;
  bool get isUpcomingLoading => _isUpcomingLoading;

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
      print("Popular Load Error: $e"); // Non-critical, just log it
    } finally {
      _isPopularLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUpcomingMovies() async {
    _isUpcomingLoading = true;
    notifyListeners();
    try {
      _upcomingMovies = await _apiService.getUpcomingMovies();
    } catch (e) {
      print("Upcoming Load Error: $e");
    } finally {
      _isUpcomingLoading = false;
      notifyListeners();
    }
  }

  // Used for Initial Load AND Infinite Scroll
  Future<void> getMovies({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _movies = [];
      _isLoading = true; // Show full spinner on reset
      notifyListeners();
    }

    try {
      final newMovies = await _apiService.getMovies(page: _currentPage);

      if (newMovies.isNotEmpty) {
        _movies.addAll(newMovies);
        _currentPage++;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
