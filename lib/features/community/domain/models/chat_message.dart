import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Real-time chat message model for community chat
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String userId,
    required String userName,
    String? userProfilePhoto,
    required String message,
    required DateTime createdAt,
    @Default(false) bool isCurrentUser,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  /// Create from Firestore document
  static ChatMessage fromFirestore(Map<String, dynamic> data, String docId) {
    return ChatMessage(
      id: docId,
      userId: (data['userId'] ?? '') as String,
      userName: (data['userName'] ?? 'Unknown User') as String,
      userProfilePhoto: data['profilePhoto'] as String?,
      message: (data['message'] ?? '') as String,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to Firestore document format
  static Map<String, dynamic> toFirestoreMap(ChatMessage message) => {
        'userId': message.userId,
        'userName': message.userName,
        'profilePhoto': message.userProfilePhoto,
        'message': message.message,
        'createdAt': message.createdAt.toIso8601String(),
      };
}
