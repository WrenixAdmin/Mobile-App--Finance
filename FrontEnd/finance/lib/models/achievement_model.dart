class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int points;
  final bool unlocked;
  final double? progress;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    this.unlocked = false,
    this.progress,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      points: json['points'],
      unlocked: json['unlocked'] ?? false,
      progress: json['progress']?.toDouble(),
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'points': points,
      'unlocked': unlocked,
      'progress': progress,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? points,
    bool? unlocked,
    double? progress,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      points: points ?? this.points,
      unlocked: unlocked ?? this.unlocked,
      progress: progress ?? this.progress,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
} 