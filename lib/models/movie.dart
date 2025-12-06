import 'movie_details_models.dart';

class Movie {
  final int id;
  final String title;
  final int year;
  final double rating;
  final List<String> genres;
  final String mediumCoverImage;
  final String summary;
  final String? backgroundImage;
  final String? descriptionFull;
  final String? ytTrailerCode;
  final int? runtime;
  final String? language; // NEW: Language
  final String? mpaRating; // NEW: MPA Rating (PG-13, R, etc.)
  final List<Torrent>? torrents;
  final List<Cast>? cast;
  final String? largeScreenshot1;
  final String? largeScreenshot2;
  final String? largeScreenshot3;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.genres,
    required this.mediumCoverImage,
    required this.summary,
    this.backgroundImage,
    this.descriptionFull,
    this.ytTrailerCode,
    this.runtime,
    this.language,
    this.mpaRating,
    this.torrents,
    this.cast,
    this.largeScreenshot1,
    this.largeScreenshot2,
    this.largeScreenshot3,
  });

  // 1. JSON Factory (Used for API) - Keep existing
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      year: json['year'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      mediumCoverImage: json['medium_cover_image'] ?? '',
      summary: json['summary'] ?? '',

      backgroundImage:
          json['background_image_original'] ?? json['background_image'],
      descriptionFull: json['description_full'] ?? json['description_intro'],
      ytTrailerCode: json['yt_trailer_code'],
      runtime: json['runtime'],
      language: json['language'] ?? 'en',
      mpaRating: json['mpa_rating'] ?? 'Unrated',

      torrents: (json['torrents'] as List<dynamic>?)
          ?.map((e) => Torrent.fromJson(e))
          .toList(),
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => Cast.fromJson(e))
          .toList(),

      // Parse Screenshots
      largeScreenshot1: json['large_screenshot_image1'],
      largeScreenshot2: json['large_screenshot_image2'],
      largeScreenshot3: json['large_screenshot_image3'],
    );
  }
  // 2. TO MAP (Used for Saving to SQL)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'rating': rating,
      'image_url': mediumCoverImage,
      'summary': summary,
      // Convert List ["Action", "Comedy"] -> String "Action,Comedy"
      'genres': genres.join(','),
    };
  }

  // 3. FROM MAP (Used for Loading from SQL)
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      year: map['year'],
      rating: map['rating'],
      mediumCoverImage: map['image_url'],
      summary: map['summary'] ?? '',
      // Convert String "Action,Comedy" -> List ["Action", "Comedy"]
      genres: (map['genres'] as String).split(','),
    );
  }
}
