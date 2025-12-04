import 'package:dio/dio.dart';
import '../constants.dart';
import '../models/movie.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Movie>> fetchMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}${AppConstants.listMoviesEndpoint}',
        queryParameters: {'limit': 20, 'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List moviesJson = data['movies'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }
}
