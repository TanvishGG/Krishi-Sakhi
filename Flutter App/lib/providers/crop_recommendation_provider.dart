import 'package:flutter/material.dart';
import '../services/crop_api_service.dart';
import '../services/gemini_service.dart';

class CropRecommendationProvider with ChangeNotifier {
  final CropApiService _apiService = CropApiService();
  final GeminiService _geminiService = GeminiService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _recommendedCrop;
  Map<String, dynamic>? _cropJustification;
  bool _isUsingFallback = false;
  String? _fallbackNote;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get recommendedCrop => _recommendedCrop;
  Map<String, dynamic>? get cropJustification => _cropJustification;
  bool get isUsingFallback => _isUsingFallback;
  String? get fallbackNote => _fallbackNote;

  Future<void> recommendCrop({
    required int n,
    required int p,
    required int k,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _recommendedCrop = null;
    _cropJustification = null;
    _isUsingFallback = false;
    _fallbackNote = null;
    notifyListeners();

    try {
      final response = await _apiService.recommendCrop(
        n: n,
        p: p,
        k: k,
        temperature: temperature,
        humidity: humidity,
        ph: ph,
        rainfall: rainfall,
      );

      _recommendedCrop = response['recommended_crop'];

      if (response.containsKey('method') &&
          response['method'] == 'fallback_algorithm') {
        _isUsingFallback = true;
        _fallbackNote =
            response['note'] ??
            'Using local recommendation algorithm due to service unavailability.';
      }

      if (_recommendedCrop != null) {
        try {
          _cropJustification = await _geminiService.generateCropJustification(
            recommendedCrop: _recommendedCrop!,
            n: n,
            p: p,
            k: k,
            temperature: temperature,
            humidity: humidity,
            ph: ph,
            rainfall: rainfall,
          );
        } catch (justificationError) {
          print('Failed to generate crop justification: $justificationError');
          _cropJustification = {
            'suitability_analysis':
                'AI analysis temporarily unavailable. The crop recommendation is still valid based on your soil parameters.',
            'environmental_factors':
                'Please verify local weather conditions match the recommended crop requirements.',
            'benefits':
                'The recommended crop is suitable for your soil conditions.',
            'risks': 'Monitor weather conditions and soil moisture levels.',
            'recommendations':
                'Consult local agricultural extension services for specific recommendations.',
          };
        }
      }
    } catch (e) {
      print('Crop recommendation error: $e');
      if (e.toString().contains('502') ||
          e.toString().contains('Bad Gateway')) {
        _errorMessage =
            'Service temporarily unavailable (502). Please try again later or contact support.';
      } else if (e.toString().contains('404') ||
          e.toString().contains('Not Found')) {
        _errorMessage =
            'Service endpoint not found. Please check your connection.';
      } else if (e.toString().contains('timeout')) {
        _errorMessage =
            'Request timed out. Please check your internet connection.';
      } else {
        _errorMessage = 'Failed to get crop recommendation: ${e.toString()}';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _recommendedCrop = null;
    _cropJustification = null;
    _errorMessage = null;
    _isUsingFallback = false;
    _fallbackNote = null;
    notifyListeners();
  }
}
