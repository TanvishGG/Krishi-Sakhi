import 'package:flutter/material.dart';
import '../services/fertilizer_api_service.dart';

class FertilizerRecommendationProvider with ChangeNotifier {
  final FertilizerApiService _apiService = FertilizerApiService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _recommendedFertilizer;
  bool _isUsingFallback = false;
  String? _fallbackNote;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get recommendedFertilizer => _recommendedFertilizer;
  bool get isUsingFallback => _isUsingFallback;
  String? get fallbackNote => _fallbackNote;

  Future<void> recommendFertilizer({
    required String soilType,
    required String cropType,
    required double temperature,
    required double humidity,
    required double moisture,
    required double nitrogen,
    required double potassium,
    required double phosphorous,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _recommendedFertilizer = null;
    _isUsingFallback = false;
    _fallbackNote = null;
    notifyListeners();

    try {
      final response = await _apiService.recommendFertilizer(
        soilType: soilType,
        cropType: cropType,
        temperature: temperature,
        humidity: humidity,
        moisture: moisture,
        nitrogen: nitrogen,
        potassium: potassium,
        phosphorous: phosphorous,
      );

      _recommendedFertilizer = response['recommended_fertilizer'];

      if (response.containsKey('method') &&
          response['method'] == 'fallback_algorithm') {
        _isUsingFallback = true;
        _fallbackNote =
            response['note'] ??
            'Using local recommendation algorithm due to service unavailability.';
      }
    } catch (e) {
      print('Fertilizer recommendation error: $e');
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
        _errorMessage =
            'Failed to get fertilizer recommendation: ${e.toString()}';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _recommendedFertilizer = null;
    _errorMessage = null;
    _isUsingFallback = false;
    _fallbackNote = null;
    notifyListeners();
  }
}
