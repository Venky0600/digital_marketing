/// VideoCallService — Video Calling Infrastructure Scaffolding
///
/// This service provides the architecture layer for video calling.
/// Currently uses ZegoCloud (zego_uikit_prebuilt_call) for the call UI.
///
/// ARCHITECTURE NOTE:
/// - Room ID generation is handled here to keep it reusable.
/// - App credentials should be injected via environment config in production.
/// - This scaffold is designed to be easily swappable with Agora or Daily.co.

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../screens/video_call_screen.dart';
import '../config/env_config.dart';

class VideoCallService {
  static const _uuid = Uuid();

  // Credentials are now securely managed in EnvConfig
  static const int zegoAppId = EnvConfig.zegoAppId;
  static const String zegoAppSign = EnvConfig.zegoAppSign;

  /// Generates a unique room/call ID for a 1-on-1 call between two users.
  static String generateCallId(String userId1, String userId2) {
    // Sort IDs to ensure both users get the same room ID regardless of who initiates
    final sorted = [userId1, userId2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  /// Generates a random room ID for group calls or anonymous sessions.
  static String generateRandomCallId() => _uuid.v4().replaceAll('-', '').substring(0, 16);

  /// Navigates to the video call screen.
  /// [callID] — The unique room identifier.
  /// [userID] — The current user's ID.
  /// [userName] — The display name shown in the call UI.
  static Future<void> startCall(
    BuildContext context, {
    required String callID,
    required String userID,
    required String userName,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          callID: callID,
          userID: userID,
          userName: userName,
        ),
      ),
    );
  }

  /// Convenience method — starts a direct 1-on-1 call with another user.
  static Future<void> callUser(
    BuildContext context, {
    required String currentUserId,
    required String currentUserName,
    required String targetUserId,
  }) async {
    final callId = generateCallId(currentUserId, targetUserId);
    await startCall(
      context,
      callID: callId,
      userID: currentUserId,
      userName: currentUserName,
    );
  }
}
