import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class FertilizerApiService {
  static const String _baseUrl = AppConstants.baseUrl;

  Map<String, dynamic> _getFallbackRecommendation({
    required String soilType,
    required String cropType,
    required double temperature,
    required double humidity,
    required double moisture,
    required double nitrogen,
    required double potassium,
    required double phosphorous,
  }) {
    String recommendedFertilizer = 'Urea';

    if (soilType.toLowerCase() == 'clayey') {
      if (cropType.toLowerCase() == 'paddy') {
        recommendedFertilizer = 'DAP';
      } else if (cropType.toLowerCase() == 'wheat') {
        recommendedFertilizer = 'NPK';
      }
    } else if (soilType.toLowerCase() == 'sandy') {
      if (nitrogen < 20) {
        recommendedFertilizer = 'Urea';
      } else {
        recommendedFertilizer = 'Potash';
      }
    } else if (soilType.toLowerCase() == 'loamy') {
      if (phosphorous < 30) {
        recommendedFertilizer = 'Superphosphate';
      } else {
        recommendedFertilizer = 'NPK';
      }
    }

    if (nitrogen < 25) {
      recommendedFertilizer = 'Urea';
    } else if (phosphorous < 35) {
      recommendedFertilizer = 'DAP';
    } else if (potassium < 40) {
      recommendedFertilizer = 'MOP';
    }

    return {
      'recommended_fertilizer': recommendedFertilizer,
      'confidence': 0.75,
      'method': 'fallback_algorithm',
      'note':
          'This is a fallback recommendation due to service unavailability. Please verify with local agricultural experts.',
    };
  }

  Future<Map<String, dynamic>> recommendFertilizer({
    required String soilType,
    required String cropType,
    required double temperature,
    required double humidity,
    required double moisture,
    required double nitrogen,
    required double potassium,
    required double phosphorous,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/predict-fertilizer');

      final body = {
        'Soil_Type': soilType,
        'Crop_Type': cropType,
        'Temparature': temperature,
        'Humidity': humidity,
        'Moisture': moisture,
        'Nitrogen': nitrogen,
        'Potassium': potassium,
        'Phosphorous': phosphorous,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return {
            'recommended_fertilizer': data['recommended_fertilizer'],
            'confidence': 0.9,
            'method': 'api',
          };
        } else {
          throw Exception(data['message'] ?? 'API returned error status');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Fertilizer API error: $e');
      return _getFallbackRecommendation(
        soilType: soilType,
        cropType: cropType,
        temperature: temperature,
        humidity: humidity,
        moisture: moisture,
        nitrogen: nitrogen,
        potassium: potassium,
        phosphorous: phosphorous,
      );
    }
  }
}
