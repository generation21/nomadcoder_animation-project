class Resource {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final List<String> platform;
  final int officialRating;
  final String trailerUrl;

  Resource({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.platform,
    required this.officialRating,
    required this.trailerUrl,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      officialRating: json['officialRating'],
      image: json['image'],
      trailerUrl: json['trailerUrl'],
      platform: List<String>.from(json['platform']),
    );
  }
}
