class AppNotification {
  final String id;
  final String type;
  final String title;
  final String message;
  final bool read;
  final DateTime createdAt;
  final DateTime? readAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.read,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      read: json['read'],
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    bool? read,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}

class NotificationPreferences {
  final bool budgetAlerts;
  final bool subscriptionAlerts;
  final bool achievementAlerts;
  final bool trendAlerts;
  final bool milestoneAlerts;

  NotificationPreferences({
    required this.budgetAlerts,
    required this.subscriptionAlerts,
    required this.achievementAlerts,
    required this.trendAlerts,
    required this.milestoneAlerts,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      budgetAlerts: json['budgetAlerts'],
      subscriptionAlerts: json['subscriptionAlerts'],
      achievementAlerts: json['achievementAlerts'],
      trendAlerts: json['trendAlerts'],
      milestoneAlerts: json['milestoneAlerts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetAlerts': budgetAlerts,
      'subscriptionAlerts': subscriptionAlerts,
      'achievementAlerts': achievementAlerts,
      'trendAlerts': trendAlerts,
      'milestoneAlerts': milestoneAlerts,
    };
  }
} 