class Exercise {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final String type;
  final bool isFavorite;

  const Exercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.type,
    this.isFavorite = false,
  });

  Exercise copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imagePath,
    String? type,
    bool? isFavorite,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

