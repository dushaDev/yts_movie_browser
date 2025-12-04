class Movie {
  final int id;
  final String title;
  final int year;
  final double rating;
  final String mediumCoverImage;
  final String summary;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.mediumCoverImage,
    required this.summary,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      year: json['year'] ?? 0,
      // Handle rating being int or double in API
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      mediumCoverImage: json['medium_cover_image'] ?? '',
      summary: json['summary'] ?? '',
    );
  }
}
