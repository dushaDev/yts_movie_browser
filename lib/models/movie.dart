class Movie {
  final int id;
  final String title;
  final int year;
  final double rating;
  final List<String> genres; // <--- Added this field
  final String mediumCoverImage;
  final String summary;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.genres, // <--- Added to constructor
    required this.mediumCoverImage,
    required this.summary,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      year: json['year'] ?? 0,

      // Handle rating safely (API sometimes sends int, sometimes double)
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,

      // Handle Genres safely (Check if null, then map to List<String>)
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],

      mediumCoverImage: json['medium_cover_image'] ?? '',
      summary: json['summary'] ?? '',
    );
  }
}