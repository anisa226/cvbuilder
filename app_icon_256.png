import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ⚠️  IMPORTANT: Fill in your own API keys before running.
/// Never commit real keys to a public repository.
abstract class ApiKeys {
  /// Get a free key at: https://openweathermap.org/api
  /// Free tier: 60 calls/minute — more than enough.
  static String get openWeatherMap => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  /// ZenQuotes — no API key required for /today endpoint (1 quote/day).
  /// Used automatically.
}

/// Supabase project credentials.
/// Find these in: Supabase Dashboard → Project Settings → API
abstract class SupabaseConfig {
  static String get url    => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
