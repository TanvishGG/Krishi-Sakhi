import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';

class WeatherData {
  final String location;
  final double temperature;
  final String description;
  final String iconUrl;
  final double humidity;
  final double windSpeed;
  final bool willRainToday;
  final Map<String, dynamic> rainPredictions;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.description,
    required this.iconUrl,
    required this.humidity,
    required this.windSpeed,
    required this.willRainToday,
    required this.rainPredictions,
  });

  factory WeatherData.fromJson(
    Map<String, dynamic> currentWeather,
    Map<String, dynamic> forecast,
  ) {
    final weatherService = WeatherService();
    final weather = currentWeather['weather']?[0];
    final main = currentWeather['main'];
    final wind = currentWeather['wind'];

    if (weather == null || main == null) {
      throw Exception('Invalid weather data format');
    }

    return WeatherData(
      location: currentWeather['name'] ?? 'Unknown Location',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      description: weatherService.getWeatherDescription(
        weather['main'] ?? 'Unknown',
        weather['description'] ?? 'No description',
      ),
      iconUrl: weatherService.getWeatherIconUrl(weather['icon'] ?? '01d'),
      humidity: (main['humidity'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (wind?['speed'] as num?)?.toDouble() ?? 0.0,
      willRainToday: weatherService.willRainToday(forecast['list'] ?? []),
      rainPredictions: weatherService.getRainPrediction(forecast['list'] ?? []),
    );
  }
}

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  Position? _currentPosition;

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentPosition => _currentPosition;

  Future<void> fetchWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPosition = await _weatherService.getCurrentLocation();

      final currentWeather = await _weatherService.getCurrentWeather(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      final forecast = await _weatherService.getWeatherForecast(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      _weatherData = WeatherData.fromJson(currentWeather, forecast);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = _getErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('Location services are disabled')) {
      return 'Location services are disabled. Please enable location services to get weather information.';
    } else if (error.contains('Location permissions are denied')) {
      return 'Location permission denied. Please grant location permission to get weather information.';
    } else if (error.contains('permanently denied')) {
      return 'Location permission permanently denied. Please enable location permission in app settings.';
    } else if (error.contains('network') || error.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else if (error.contains('API key')) {
      return 'Weather service configuration error. Please contact support.';
    } else {
      return 'Unable to fetch weather data. Please try again later.';
    }
  }

  Future<void> refreshWeather() async {
    if (_currentPosition != null) {
      await fetchWeather();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Location permissions are denied';
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error =
            'Location permissions are permanently denied. Please enable them in settings.';
        notifyListeners();
        return;
      }

      await fetchWeather();
    } catch (e) {
      _error = 'Failed to request location permission: $e';
      notifyListeners();
    }
  }

  Map<String, dynamic>? getRainPredictionForDay(int daysFromNow) {
    if (_weatherData == null || _weatherData!.rainPredictions.isEmpty) {
      return null;
    }

    final targetDate = DateTime.now().add(Duration(days: daysFromNow));
    final targetDateString = targetDate.toString().split(' ')[0];

    return _weatherData!.rainPredictions[targetDateString];
  }

  Map<String, dynamic>? getMonthlyWeatherAverages() {
    if (_weatherData == null) return null;

    final now = DateTime.now();
    final forecastData = _weatherData!.rainPredictions;

    if (forecastData.isEmpty) return null;

    double totalTemp = 0.0;
    double totalHumidity = 0.0;
    double totalRainfall = 0.0;
    int dataPoints = 0;
    int rainyDays = 0;

    forecastData.forEach((dateString, prediction) {
      final date = DateTime.parse(dateString);
      final daysDiff = date.difference(now).inDays;

      if (daysDiff >= 0 && daysDiff <= 30) {
        totalTemp += _weatherData!.temperature;
        totalHumidity += _weatherData!.humidity;

        if (prediction['will_rain'] == true) {
          rainyDays++;
          final actualRainfall = prediction['rain_amount'] ?? 0.0;
          if (actualRainfall > 0.0) {
            totalRainfall += actualRainfall;
          } else {
            final rainChance = prediction['rain_chance'] ?? 0;
            totalRainfall += (rainChance / 100.0) * 5.0;
          }
        }

        dataPoints++;
      }
    });

    if (dataPoints == 0) return null;

    final currentMonth = now.month;
    double seasonalTempAdjustment = 0.0;
    double seasonalHumidityAdjustment = 0.0;

    if (currentMonth >= 3 && currentMonth <= 5) {
      seasonalTempAdjustment = 2.0;
      seasonalHumidityAdjustment = -5.0;
    } else if (currentMonth >= 6 && currentMonth <= 8) {
      seasonalTempAdjustment = 5.0;
      seasonalHumidityAdjustment = -10.0;
    } else if (currentMonth >= 9 && currentMonth <= 11) {
      seasonalTempAdjustment = 1.0;
      seasonalHumidityAdjustment = 5.0;
    } else {
      seasonalTempAdjustment = -3.0;
      seasonalHumidityAdjustment = 10.0;
    }

    final avgTemp = (totalTemp / dataPoints) + seasonalTempAdjustment;
    final avgHumidity =
        (totalHumidity / dataPoints) + seasonalHumidityAdjustment;
    final avgRainfall = totalRainfall / dataPoints * 30;

    return {
      'average_temperature': avgTemp.clamp(0.0, 50.0),
      'average_humidity': avgHumidity.clamp(10.0, 100.0),
      'monthly_rainfall': avgRainfall.clamp(0.0, 500.0),
      'rainy_days': rainyDays,
      'forecast_period_days': dataPoints,
    };
  }

  bool willRainInNextDays(int days) {
    for (int i = 0; i < days; i++) {
      final prediction = getRainPredictionForDay(i);
      if (prediction != null && prediction['will_rain'] == true) {
        return true;
      }
    }
    return false;
  }
}
