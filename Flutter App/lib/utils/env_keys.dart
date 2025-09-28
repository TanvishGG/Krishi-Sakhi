import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvKeys {
  static String get openWeatherApiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get schemesLoansApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}
