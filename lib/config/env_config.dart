/// EnvConfig — Secure Configuration Management
///
/// This class handles all sensitive API keys and environment-specific settings.
/// In production, these should be passed via --dart-define or --dart-define-from-file.
class EnvConfig {
  // ZegoCloud Credentials
  static const int zegoAppId = int.fromEnvironment(
    'ZEGO_APP_ID',
    defaultValue: 0,
  );

  static const String zegoAppSign = String.fromEnvironment(
    'ZEGO_APP_SIGN',
    defaultValue: '',
  );

  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000/api',
  );

  // Feature Flags
  static const bool enableAiMatchmaking = bool.fromEnvironment(
    'ENABLE_AI',
    defaultValue: true,
  );

  /// Helper to check if credentials are valid
  static bool get hasZegoCredentials => zegoAppId != 0 && zegoAppSign.isNotEmpty;
}
