import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Movie> _movies = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getMovies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Update UI to show loading spinner

    try {
      final newMovies = await _apiService.fetchMovies();
      _movies = newMovies;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Update UI to show data or error
    }
  }
}
