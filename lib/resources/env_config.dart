import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class to access environment variables
/// 
/// Usage:
/// ```dart
/// await dotenv.load(fileName: ".env");
/// print(EnvConfig.firebaseApiKey);
/// ```
class EnvConfig {
  // ============================================
  // Firebase Configuration
  // ============================================
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseAuthDomain =>
      dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
  static String get firebaseStorageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
  static String get firebaseMeasurementId =>
      dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '';

  // ============================================
  // Google Apps Script APIs
  // ============================================
  static String get apiEnviarSolpe => dotenv.env['API_ENVIAR_SOLPE'] ?? '';
  static String get apiFem => dotenv.env['API_FEM'] ?? '';
  static String get apiSam => dotenv.env['API_SAM'] ?? '';
  static String get apiSamat => dotenv.env['API_SAMAT'] ?? '';

  // ============================================
  // Supabase Configuration
  // ============================================
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // ============================================
  // Validation
  // ============================================
  
  /// Validates that all required environment variables are set
  static bool validate() {
    final requiredVars = [
      firebaseApiKey,
      firebaseAppId,
      firebaseMessagingSenderId,
      firebaseProjectId,
      firebaseAuthDomain,
      firebaseStorageBucket,
      apiEnviarSolpe,
      apiFem,
      apiSam,
      apiSamat,
      supabaseUrl,
      supabaseAnonKey,
    ];
    
    return requiredVars.every((v) => v.isNotEmpty);
  }

  /// Returns a list of missing environment variables
  static List<String> getMissingVariables() {
    final vars = <String, String>{
      'FIREBASE_API_KEY': firebaseApiKey,
      'FIREBASE_APP_ID': firebaseAppId,
      'FIREBASE_MESSAGING_SENDER_ID': firebaseMessagingSenderId,
      'FIREBASE_PROJECT_ID': firebaseProjectId,
      'FIREBASE_AUTH_DOMAIN': firebaseAuthDomain,
      'FIREBASE_STORAGE_BUCKET': firebaseStorageBucket,
      'API_ENVIAR_SOLPE': apiEnviarSolpe,
      'API_FEM': apiFem,
      'API_SAM': apiSam,
      'API_SAMAT': apiSamat,
      'SUPABASE_URL': supabaseUrl,
      'SUPABASE_ANON_KEY': supabaseAnonKey,
    };
    
    return vars.entries
        .where((e) => e.value.isEmpty)
        .map((e) => e.key)
        .toList();
  }
}

