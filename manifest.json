import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../core/constants/api_keys.dart';

class WeatherData {
  final String city;
  final double tempC;
  final String condition;   // e.g. "Clear", "Clouds"
  final String iconCode;    // e.g. "01d"

  const WeatherData({
    required this.city,
    required this.tempC,
    required this.condition,
    required this.iconCode,
  });

  String get emoji {
    if (iconCode.isEmpty) return '🌤️';
    if (iconCode.length < 2) return '🌤️';
    switch (iconCode.substring(0, 2)) {
      case '01': return '☀️';
      case '02': return '⛅';
      case '03':
      case '04': return '☁️';
      case '09':
      case '10': return '🌧️';
      case '11': return '⛈️';
      case '13': return '❄️';
      case '50': return '🌫️';
      default:   return '🌤️';
    }
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'tempC': tempC,
        'condition': condition,
        'iconCode': iconCode,
      };

  factory WeatherData.fromJson(Map<String, dynamic> j) => WeatherData(
        city: j['city'] as String,
        tempC: (j['tempC'] as num).toDouble(),
        condition: j['condition'] as String,
        iconCode: j['iconCode'] as String,
      );
}

class WeatherService {
  static const _cacheKey = 'weather_cache';
  static const _cacheTimeKey = 'weather_cache_time';
  static const _cacheDurationMinutes = 30;

  // ── Fetch weather (with location auto-detect) ─────────────────
  Future<WeatherData?> fetchWeather() async {
    // 1. Try to return cached data if recent enough
    final cached = await _getCached();
    if (cached != null) return cached;

    // 2. Try GPS location
    try {
      final position = await _getPosition();
      if (position != null) {
        return await _fetchByLatLon(position.latitude, position.longitude);
      }
    } catch (_) {}

    // 3. Fallback: fetch by default city
    return await _fetchByCity('Dhaka');
  }

  // ── Fetch by explicit city name (manual override) ─────────────
  Future<WeatherData?> fetchByCity(String city) => _fetchByCity(city);

  // ── Private helpers ───────────────────────────────────────────
  Future<Position?> _getPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }

  Future<WeatherData?> _fetchByLatLon(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
      '?lat=$lat&lon=$lon&appid=${ApiKeys.openWeatherMap}&units=metric',
    );
    return _request(url);
  }

  Future<WeatherData?> _fetchByCity(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
      '?q=${Uri.encodeComponent(city)}&appid=${ApiKeys.openWeatherMap}&units=metric',
    );
    return _request(url);
  }

  Future<WeatherData?> _request(Uri url) async {
    try {
      final res = await http.get(url).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) {
        print('Weather API Error: ${res.statusCode} - ${res.body}');
        return null;
      }
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      final w = WeatherData(
        city: j['name'] as String,
        tempC: (j['main']['temp'] as num).toDouble(),
        condition: (j['weather'] as List).first['main'] as String,
        iconCode: (j['weather'] as List).first['icon'] as String,
      );
      print('Weather Fetch successful for: ${w.city}');
      await _saveCache(w);
      return w;
    } catch (e) {
      print('Weather Exception: $e');
      return null;
    }
  }

  Future<WeatherData?> _getCached() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(_cacheTimeKey);
    if (timeStr == null) return null;
    final cacheTime = DateTime.parse(timeStr);
    if (DateTime.now().difference(cacheTime).inMinutes > _cacheDurationMinutes) {
      return null;
    }
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return null;
    return WeatherData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _saveCache(WeatherData w) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(w.toJson()));
    await prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());
  }
}
