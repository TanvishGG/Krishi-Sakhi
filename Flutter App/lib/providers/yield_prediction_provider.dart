import 'package:flutter/material.dart';
import '../services/crop_api_service.dart';
import '../services/gemini_service.dart';

class YieldPredictionProvider with ChangeNotifier {
  final CropApiService _apiService = CropApiService();
  final GeminiService _geminiService = GeminiService();

  bool _isLoading = false;
  String? _errorMessage;
  double? _predictedYield;
  Map<String, dynamic>? _marketAnalysis;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double? get predictedYield => _predictedYield;
  Map<String, dynamic>? get marketAnalysis => _marketAnalysis;

  Future<void> predictYield({
    required String state,
    required String district,
    required String crop,
    required String season,
    required double area,
    required int year,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _predictedYield = null;
    _marketAnalysis = null;
    notifyListeners();

    try {
      final response = await _apiService.predictYield(
        state: state,
        district: district,
        crop: crop,
        season: season,
        area: area,
        year: year,
      );

      _predictedYield = response['predicted_yield'];

      if (_predictedYield != null) {
        try {
          print('Generating market analysis for crop: $crop');
          _marketAnalysis = await _geminiService.generateMarketAnalysis(
            crop: crop,
            state: state,
            district: district,
            predictedYield: _predictedYield!,
            area: area,
            season: season,
            year: year,
          );
          print('Market analysis generated successfully: $_marketAnalysis');
        } catch (analysisError) {
          print('Failed to generate market analysis: $analysisError');
          _marketAnalysis = {
            'current_market_price': 45.0,
            'price_range': {'min': 35.0, 'max': 55.0},
            'profit_analysis': {
              'total_revenue': 225000.0,
              'estimated_costs': 125000.0,
              'net_profit': 100000.0,
              'profit_per_hectare': 50000.0,
            },
            'market_trends':
                'Market analysis temporarily unavailable. Please consult local market experts.',
            'selling_strategies':
                'Contact local agricultural market for selling advice.',
            'risk_factors':
                'Market risks should be assessed with local agricultural extension services.',
            'government_support':
                'Check with local agricultural office for MSP and government schemes.',
          };
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _predictedYield = null;
    _marketAnalysis = null;
    _errorMessage = null;
    notifyListeners();
  }
}
