class Torrent {
  final String url;
  final String hash;
  final String quality; // "720p", "1080p"
  final String type; // "bluray", "web"
  final String size;
  final int seeds;
  final int peers;

  Torrent({
    required this.url,
    required this.hash,
    required this.quality,
    required this.type,
    required this.size,
    required this.seeds,
    required this.peers,
  });

  factory Torrent.fromJson(Map<String, dynamic> json) {
    return Torrent(
      url: json['url'] ?? '',
      hash: json['hash'] ?? '',
      quality: json['quality'] ?? 'Unknown',
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      seeds: json['seeds'] ?? 0,
      peers: json['peers'] ?? 0,
    );
  }
}

class Cast {
  final String name;
  final String characterName;
  final String urlSmallImage;

  Cast({
    required this.name,
    required this.characterName,
    required this.urlSmallImage,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'] ?? 'Unknown',
      characterName: json['character_name'] ?? '',
      urlSmallImage: json['url_small_image'] ?? '',
    );
  }
}
