import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math';

class VideoCallScreen extends StatelessWidget {
  final String callID;
  final String userName;
  final String userID;

  const VideoCallScreen({
    Key? key,
    required this.callID,
    required this.userName,
    required this.userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Note: ZegoCloud AppID and AppSign should be provided by your ZegoCloud console.
    // For production, these should be securely fetched from backend or stored in env vars.
    // Replace with your actual AppID and AppSign.
    const int appID = 123456789; // Placeholder
    const String appSign = "PLACEHOLDER_APP_SIGN"; // Placeholder

    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        callID: callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
