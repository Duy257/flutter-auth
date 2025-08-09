import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Private constructor
  EnvConfig._();

  // Singleton instance
  static final EnvConfig _instance = EnvConfig._();
  static EnvConfig get instance => _instance;

  // Initialize environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  String get baseUrl {
    switch (dotenv.env['APP_ENVIRONMENT']) {
      case 'local':
        return dotenv.env['API_URL_LOCAL'] ?? '';
      case 'dev':
        return dotenv.env['API_URL_DEV'] ?? '';
      case 'prod':
        return dotenv.env['API_URL_PROD'] ?? '';
      default:
        return '';
    }
  }

  // Google Sign-In Configuration
  String get googleAndroidClientId =>
      dotenv.env['GOOGLE_ANDROID_CLIENT_ID'] ?? '';

  String get googleIosClientId => dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '';

  String get googleWebClientId => dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  String get googleServerClientId =>
      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';

  String get googleReversedClientId =>
      dotenv.env['GOOGLE_REVERSED_CLIENT_ID'] ?? '';

  List<String> get googleScopes {
    final scopesString = dotenv.env['GOOGLE_SCOPES'] ?? 'email,profile';
    return scopesString.split(',').map((scope) => scope.trim()).toList();
  }

  // App Configuration
  String get appName => dotenv.env['APP_NAME'] ?? 'Flutter App';
  String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  String get appEnvironment => dotenv.env['APP_ENVIRONMENT'] ?? 'development';

  // Firebase Configuration
  String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';

  // Debug Settings
  bool get debugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  bool get enableLogging =>
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

  // Validation methods
  bool get isGoogleSignInConfigured {
    return googleAndroidClientId.isNotEmpty ||
        googleIosClientId.isNotEmpty ||
        googleWebClientId.isNotEmpty;
  }

  bool get isFirebaseConfigured {
    return firebaseProjectId.isNotEmpty &&
        firebaseApiKey.isNotEmpty &&
        firebaseAppId.isNotEmpty;
  }

  // Get client ID based on platform
  String getClientIdForPlatform() {
    // This would be determined at runtime based on platform
    // For now, return Android client ID as default
    return googleAndroidClientId;
  }

  // Print configuration (for debugging)
  void printConfig() {
    if (!enableLogging) return;

    print('=== Environment Configuration ===');
    print('App Name: $appName');
    print('App Version: $appVersion');
    print('Environment: $appEnvironment');
    print('Debug Mode: $debugMode');
    print('Google Sign-In Configured: $isGoogleSignInConfigured');
    print('Firebase Configured: $isFirebaseConfigured');
    print('Google Scopes: ${googleScopes.join(', ')}');
    print('================================');
  }

  // Validate required configuration
  List<String> validateConfiguration() {
    final errors = <String>[];

    if (!isGoogleSignInConfigured) {
      errors.add('Google Sign-In client IDs are not configured');
    }

    if (googleScopes.isEmpty) {
      errors.add('Google scopes are not configured');
    }

    return errors;
  }
}
