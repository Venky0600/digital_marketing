class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String message;
  final DateTime timestamp;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.message,
    required this.timestamp,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName']?.toString() ?? 'User',
      senderAvatar: json['senderAvatar']?.toString() ?? 'https://i.pravatar.cc/150',
      message: json['message']?.toString() ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      isMe: json['isMe'] ?? false,
    );
  }
}

class AiChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const AiChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}
