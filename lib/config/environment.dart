// Environment configuration for my_health_core.
//
// Values are injected at build time via:
//   flutter run    --dart-define-from-file=env/dev.json
//   flutter build  --dart-define-from-file=env/prod.json
//
// All const String.fromEnvironment() calls are replaced at compile time,
// so this file is tree-shake friendly and adds zero runtime cost.

enum Flavor { dev, staging, prod }

class Environment {
  Environment._();

  /// Build flavor. Defaults to `dev` when not provided.
  static const String _flavorRaw = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static Flavor get flavor {
    switch (_flavorRaw) {
      case 'prod':
        return Flavor.prod;
      case 'staging':
        return Flavor.staging;
      case 'dev':
      default:
        return Flavor.dev;
    }
  }

  static bool get isProd => flavor == Flavor.prod;
  static bool get isStaging => flavor == Flavor.staging;
  static bool get isDev => flavor == Flavor.dev;

  /// Human-readable label shown in debug banners / about screens.
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'My Health Core (Dev)',
  );

  /// Base URL for the backend API.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev.api.myhealthcore.local',
  );

  /// Firebase project id - useful when validating which project a build
  /// is talking to (matches firebase_options.dart at build time).
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'hiv-prevention-app',
  );

  /// Toggle verbose logging - should be false for prod builds.
  static const bool enableVerboseLogging = bool.fromEnvironment(
    'ENABLE_VERBOSE_LOGGING',
    defaultValue: true,
  );

  /// Toggle Firebase Analytics collection. Disabled by default in dev so
  /// we don't pollute production dashboards.
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  /// Toggle Crashlytics / crash reporting upload.
  static const bool enableCrashReporting = bool.fromEnvironment(
    'ENABLE_CRASH_REPORTING',
    defaultValue: false,
  );

  /// Sentinel to detect misconfigured release builds. main.dart should
  /// `assert(Environment.isConfigured)` early on.
  static bool get isConfigured =>
      apiBaseUrl.isNotEmpty && firebaseProjectId.isNotEmpty;

  /// Convenience for logging at startup.
  static Map<String, Object> describe() => {
        'flavor': _flavorRaw,
        'appName': appName,
        'apiBaseUrl': apiBaseUrl,
        'firebaseProjectId': firebaseProjectId,
        'enableVerboseLogging': enableVerboseLogging,
        'enableAnalytics': enableAnalytics,
        'enableCrashReporting': enableCrashReporting,
      };
}
