class WorkoutType {
  final String id;
  final String name;
  final String iconPath;
  final bool isSelected;

  const WorkoutType({
    required this.id,
    required this.name,
    required this.iconPath,
    this.isSelected = false,
  });

  WorkoutType copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isSelected,
  }) {
    return WorkoutType(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

