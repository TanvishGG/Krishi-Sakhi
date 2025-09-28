import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CropApiService {
  static const String _baseUrl = 'https://tunnel-8000.tanvish.co.in/';

  Map<String, dynamic> _getFallbackRecommendation({
    required int n,
    required int p,
    required int k,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) {
    String recommendedCrop = 'Rice';

    if (temperature >= 20 && temperature <= 30) {
      if (rainfall > 150) {
        recommendedCrop = 'Rice';
      } else if (n > 50 && p > 30) {
        recommendedCrop = 'Wheat';
      } else if (k > 40) {
        recommendedCrop = 'Sugarcane';
      }
    } else if (temperature >= 15 && temperature < 20) {
      if (rainfall > 100) {
        recommendedCrop = 'Wheat';
      } else {
        recommendedCrop = 'Barley';
      }
    } else if (temperature > 30) {
      if (humidity > 60 && rainfall > 200) {
        recommendedCrop = 'Rice';
      } else {
        recommendedCrop = 'Cotton';
      }
    }

    if (ph < 5.5) {
      if (recommendedCrop == 'Rice') {
        recommendedCrop = 'Rice';
      }
    } else if (ph > 8.0) {
      recommendedCrop = 'Barley';
    }

    if (n > 80 && p > 50 && k > 60) {
      recommendedCrop = 'Sugarcane';
    } else if (n < 30) {
      recommendedCrop = 'Pulses';
    }

    return {
      'recommended_crop': recommendedCrop,
      'confidence': 0.75,
      'method': 'fallback_algorithm',
      'note':
          'This is a fallback recommendation due to service unavailability. Please verify with local agricultural experts.',
    };
  }

  Future<Map<String, dynamic>> recommendCrop({
    required int n,
    required int p,
    required int k,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/predict');

      final body = {
        'N': n,
        'P': p,
        'K': k,
        'temperature': temperature,
        'humidity': humidity,
        'ph': ph,
        'rainfall': rainfall,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 502) {
        print('ML API returned 502, using fallback recommendation');
        return _getFallbackRecommendation(
          n: n,
          p: p,
          k: k,
          temperature: temperature,
          humidity: humidity,
          ph: ph,
          rainfall: rainfall,
        );
      } else if (response.statusCode == 404) {
        print('ML API endpoint not found, using fallback recommendation');
        return _getFallbackRecommendation(
          n: n,
          p: p,
          k: k,
          temperature: temperature,
          humidity: humidity,
          ph: ph,
          rainfall: rainfall,
        );
      } else if (response.statusCode == 500) {
        print('ML API server error, using fallback recommendation');
        return _getFallbackRecommendation(
          n: n,
          p: p,
          k: k,
          temperature: temperature,
          humidity: humidity,
          ph: ph,
          rainfall: rainfall,
        );
      } else if (response.statusCode == 429) {
        print('ML API rate limited, using fallback recommendation');
        return _getFallbackRecommendation(
          n: n,
          p: p,
          k: k,
          temperature: temperature,
          humidity: humidity,
          ph: ph,
          rainfall: rainfall,
        );
      } else {
        print(
          'ML API returned status ${response.statusCode}, using fallback recommendation',
        );
        return _getFallbackRecommendation(
          n: n,
          p: p,
          k: k,
          temperature: temperature,
          humidity: humidity,
          ph: ph,
          rainfall: rainfall,
        );
      }
    } catch (e) {
      print('Network error accessing ML API: $e');
      print('Using fallback recommendation algorithm');

      return _getFallbackRecommendation(
        n: n,
        p: p,
        k: k,
        temperature: temperature,
        humidity: humidity,
        ph: ph,
        rainfall: rainfall,
      );
    }
  }

  Future<Map<String, dynamic>> predictYield({
    required String state,
    required String district,
    required String crop,
    required String season,
    required double area,
    required int year,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/predict-yield');

      final body = {
        'state': state,
        'district': district,
        'crop': crop,
        'season': season,
        'area': area,
        'year': year,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to predict yield: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    try {
      final url = Uri.parse('$_baseUrl/predict-disease');

      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);
        if (responseData['status'] == 'success') {
          return {
            'final_prediction': responseData['final_prediction'],
            'confidence': responseData['confidence'] ?? 0.95,
          };
        } else {
          throw Exception('API Error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to detect disease: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> predictPest(File imageFile) async {
    try {
      final url = Uri.parse('$_baseUrl/predict-pest');

      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);
        if (responseData['status'] == 'success') {
          return {'pest': responseData['prediction'], 'confidence': 0.95};
        } else {
          throw Exception('API Error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to detect pest: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
