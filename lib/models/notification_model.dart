enum NotificationType { newCampaign, match, message, general }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Notification',
      body: json['body']?.toString() ?? '',
      type: _parseType(json['type']?.toString()),
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  static NotificationType _parseType(String? t) {
    switch (t?.toLowerCase()) {
      case 'newcampaign': return NotificationType.newCampaign;
      case 'match':       return NotificationType.match;
      case 'message':     return NotificationType.message;
      default:            return NotificationType.general;
    }
  }
}
