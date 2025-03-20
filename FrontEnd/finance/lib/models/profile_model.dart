class NotificationPreferences {
  final bool email;
  final bool push;
  final bool sms;

  NotificationPreferences({
    this.email = false,
    this.push = false,
    this.sms = false,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      email: json['email'] ?? false,
      push: json['push'] ?? false,
      sms: json['sms'] ?? false,
    );
  }
}

class Profile {
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? currency;
  final String? language;
  final String? timezone;
  final NotificationPreferences? notificationPreferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;

  Profile({
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.currency,
    this.language,
    this.timezone,
    this.notificationPreferences,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      currency: json['currency'],
      language: json['language'],
      timezone: json['timezone'],
      notificationPreferences: json['notificationPreferences'] != null
          ? NotificationPreferences.fromJson(json['notificationPreferences'])
          : null,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
      lastLoginAt: json['lastLoginAt'] != null 
          ? _parseTimestamp(json['lastLoginAt'])
          : null,
    );
  }

  static DateTime _parseTimestamp(Map<String, dynamic> timestamp) {
    final seconds = timestamp['_seconds'] as int;
    final nanoseconds = timestamp['_nanoseconds'] as int;
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + (nanoseconds / 1000000).round());
  }
}