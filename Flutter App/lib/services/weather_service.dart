import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/constants.dart';
import '../utils/env_keys.dart';

class WeatherService {
  final Dio _dio = Dio();
  static const String _baseUrl = AppConstants.openWeatherBaseUrl;
  static String get _apiKey => EnvKeys.openWeatherApiKey;

  WeatherService() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please check your OpenWeather API key configuration.',
        );
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        throw Exception(
          'Failed to load weather data (HTTP ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception(
            'Connection timeout. Please check your internet connection.',
          );
        } else if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception('Server response timeout. Please try again.');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception(
            'Network connection error. Please check your internet connection.',
          );
        }
      }
      throw Exception('Weather service error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getWeatherForecast(
    double lat,
    double lon,
  ) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please check your OpenWeather API key configuration.',
        );
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        throw Exception(
          'Failed to load forecast data (HTTP ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception(
            'Connection timeout. Please check your internet connection.',
          );
        } else if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception('Server response timeout. Please try again.');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception(
            'Network connection error. Please check your internet connection.',
          );
        }
      }
      throw Exception('Forecast service error: ${e.toString()}');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Location services are disabled. Please enable location services in your device settings.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permissions are denied. Please grant location permission to use weather features.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable location permission in app settings.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      throw Exception(
        'Unable to get current location. Please check your GPS and try again.',
      );
    }
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  String getWeatherDescription(String main, String description) {
    return '${main[0].toUpperCase()}${main.substring(1).toLowerCase()}: ${description[0].toUpperCase()}${description.substring(1).toLowerCase()}';
  }

  bool willRainToday(List<dynamic> forecastList) {
    final today = DateTime.now();
    final todayString = today.toString().split(' ')[0];

    for (var item in forecastList) {
      final forecastDate = DateTime.fromMillisecondsSinceEpoch(
        item['dt'] * 1000,
      );
      final forecastDateString = forecastDate.toString().split(' ')[0];

      if (forecastDateString == todayString) {
        final weather = item['weather'][0];
        final main = weather['main'].toLowerCase();
        if (main.contains('rain') ||
            main.contains('drizzle') ||
            main.contains('thunderstorm')) {
          return true;
        }
      }
    }
    return false;
  }

  Map<String, dynamic> getRainPrediction(List<dynamic> forecastList) {
    final predictions = <String, dynamic>{};
    final now = DateTime.now();

    for (var item in forecastList) {
      final forecastTime = DateTime.fromMillisecondsSinceEpoch(
        item['dt'] * 1000,
      );
      final weather = item['weather'][0];
      final main = weather['main'].toLowerCase();

      if (forecastTime.difference(now).inDays <= 5) {
        final dayKey = forecastTime.toString().split(' ')[0];
        if (!predictions.containsKey(dayKey)) {
          predictions[dayKey] = {
            'date': forecastTime,
            'will_rain': false,
            'rain_chance': 0.0,
            'rain_amount': 0.0,
            'description': weather['description'],
          };
        }

        if (main.contains('rain') ||
            main.contains('drizzle') ||
            main.contains('thunderstorm')) {
          predictions[dayKey]['will_rain'] = true;
          predictions[dayKey]['rain_chance'] = (item['pop'] * 100).round();

          if (item['rain'] != null && item['rain']['3h'] != null) {
            predictions[dayKey]['rain_amount'] = (item['rain']['3h'] as num)
                .toDouble();
          }
        }
      }
    }

    return predictions;
  }
}
