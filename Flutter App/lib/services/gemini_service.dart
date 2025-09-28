import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/env_keys.dart';

class GeminiService {
  static String get _apiKey => EnvKeys.geminiApiKey;

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
  }

  Future<String> generateResponse(
    String prompt, {
    String? context,
  }) async {
    try {
      final systemPrompt =
          '''
You are Krishi Sakhi, an expert agricultural assistant for Indian farmers. You provide helpful, accurate, and practical advice about:

- Crop selection and management
- Soil health and fertilization
- Pest and disease management
- Irrigation techniques
- Weather-based farming decisions
- Sustainable farming practices
- Government schemes and subsidies
- Market prices and trends
- Organic farming methods
- Modern farming technologies

Always respond in English.

Always respond in a friendly, helpful manner. If you don't know something specific to Indian agriculture, admit it and suggest consulting local agricultural experts or extension services.

Keep responses concise but informative. Use simple language that farmers can easily understand.

${context != null ? 'Previous conversation context: $context' : ''}
''';

      final fullPrompt = '$systemPrompt\n\nUser: $prompt\n\nAssistant:';

      final response = await _model.generateContent([Content.text(fullPrompt)]);

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'I apologize, but I couldn\'t generate a response. Please try again.';
      }
    } catch (e) {
      return 'I\'m sorry, I\'m having trouble connecting to my knowledge base right now. Please try again in a moment.';
    }
  }

  Future<String> generateVoiceResponse(
    String transcription, {
    String? context,
  }) async {
    try {
      if (transcription.trim().isEmpty) {
        return 'I\'m sorry, I couldn\'t hear anything. Please try speaking again.';
      }

      if (transcription.trim().length < 2) {
        return 'I\'m sorry, I couldn\'t understand that clearly. Could you please speak a bit more?';
      }

      final voicePrompt =
          '''
You are Krishi Sakhi, a helpful agricultural assistant. The user has spoken their question about farming.

Respond in English with:
- do not use formatting symbols, be concise
- Simple, clear language
- Practical farming advice
- If unclear, ask for clarification

${context != null ? 'Previous context: $context' : ''}

User said: "$transcription"

Your response:''';

      final response = await _model.generateContent([
        Content.text(voicePrompt),
      ]);

      if (response.text != null && response.text!.trim().isNotEmpty) {
        return response.text!.trim();
      } else {
        return 'I\'m sorry, I couldn\'t generate a response. Please try again.';
      }
    } catch (e) {
      final lowerText = transcription.toLowerCase();
      if (lowerText.contains('hello') || lowerText.contains('hi')) {
        return 'Hello! I\'m Krishi Sakhi. How can I help you with farming today?';
      }
      if (lowerText.contains('help')) {
        return 'I can help you with crops, pests, soil, and farming questions. What do you need to know?';
      }

      return 'I\'m having connection issues right now. Please try again in a moment.';
    }
  }

  Future<String> analyzeImageWithText(
    String imageDescription,
    String userQuery,
  ) async {
    try {
      final imagePrompt =
          '''
You are Krishi Sakhi, an agricultural expert analyzing a plant image. The user has described what they see in the image and asked a question about it.

Image description: $imageDescription
User question: $userQuery

Provide helpful analysis and advice based on the image description. Focus on:
- Plant health assessment
- Potential issues or diseases
- Treatment recommendations
- Prevention tips
- When to seek professional help

Be practical and specific in your advice.
''';

      final response = await _model.generateContent([
        Content.text(imagePrompt),
      ]);

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'I\'m sorry, I couldn\'t analyze the image properly. Please try again.';
      }
    } catch (e) {
      return 'I\'m sorry, I\'m having trouble analyzing the image. Please try again.';
    }
  }

  Future<Map<String, dynamic>> generateCropJustification({
    required String recommendedCrop,
    required int n,
    required int p,
    required int k,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    try {
      final prompt =
          '''
You are an agricultural expert providing focused justification for crop recommendations.

Parameters: N=${n} mg/kg, P=${p} mg/kg, K=${k} mg/kg, pH=${ph}, Temp=${temperature}°C, Humidity=${humidity}%, Rainfall=${rainfall}mm

Why is "${recommendedCrop}" the best choice? Provide a detailed yet concise response with:

1. **Nutrient Match**: How NPK levels support this crop's growth requirements (3-4 key points)
2. **Climate Suitability**: Why temperature, humidity, and rainfall conditions are ideal (3 points)
3. **Key Benefits**: Top 3 advantages of growing this crop in these conditions
4. **Risk Factors**: 2 potential challenges and how to mitigate them
5. **Essential Tips**: 3 specific farming recommendations for success

Keep response practical and informative. Format as JSON: {"nutrient_match": "...", "climate_suitability": "...", "benefits": "...", "risks": "...", "tips": "..."}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      final jsonStart = responseText.indexOf('{');
      final jsonEnd = responseText.lastIndexOf('}') + 1;

      if (jsonStart == -1 || jsonEnd == -1) {
        throw Exception('Invalid JSON response format');
      }

      final jsonString = responseText.substring(jsonStart, jsonEnd);

      return _parseJsonResponse(jsonString);
    } catch (e) {
      throw Exception('Failed to generate crop justification: $e');
    }
  }

  Map<String, dynamic> _parseJsonResponse(String jsonString) {
    String cleanJson = jsonString
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final sections = <String, dynamic>{};
    final patterns = {
      'nutrient_match': r'"nutrient_match"\s*:\s*"([^"]*(?:\\.[^"]*)*)"',
      'climate_suitability':
          r'"climate_suitability"\s*:\s*"([^"]*(?:\\.[^"]*)*)"',
      'benefits': r'"benefits"\s*:\s*"([^"]*(?:\\.[^"]*)*)"',
      'risks': r'"risks"\s*:\s*"([^"]*(?:\\.[^"]*)*)"',
      'tips': r'"tips"\s*:\s*"([^"]*(?:\\.[^"]*)*)"',
    };

    for (final entry in patterns.entries) {
      final match = RegExp(
        entry.value,
        caseSensitive: false,
      ).firstMatch(cleanJson);
      if (match != null && match.groupCount >= 1) {
        sections[entry.key] = match
            .group(1)
            ?.replaceAll(r'\n', '\n')
            .replaceAll(r'\"', '"');
      }
    }

    return sections;
  }

  Future<Map<String, dynamic>> generateMarketAnalysis({
    required String crop,
    required String state,
    required String district,
    required double predictedYield,
    required double area,
    required String season,
    required int year,
  }) async {

    try {
      final totalProduction = predictedYield * area;

      final prompt =
          '''
You are an agricultural market expert providing detailed market price and profit analysis for Indian farmers.

Crop: ${crop}
Location: ${district}, ${state}
Season: ${season}
Year: ${year}
Predicted Yield: ${predictedYield.toStringAsFixed(2)} tons/hectare
Area: ${area.toStringAsFixed(2)} hectares
Total Production: ${totalProduction.toStringAsFixed(2)} tons

Provide market analysis with REALISTIC current prices in INR. Use proper Indian agricultural market pricing:

**IMPORTANT PRICING GUIDELINES:**
- Rice/Paddy: ₹18-25 per kg
- Wheat: ₹20-28 per kg  
- Maize: ₹15-22 per kg
- Cotton: ₹45-65 per kg
- Sugarcane: ₹2.50-3.50 per kg
- Vegetables (Tomato/Potato/Onion): ₹10-30 per kg
- Fruits (Mango/Orange): ₹20-50 per kg
- Pulses (Tur/Moong/Urad): ₹60-120 per kg
- Oilseeds (Soybean/Groundnut): ₹35-55 per kg

**PROFIT CALCULATION:**
- Production is in tons, prices in ₹/kg
- Total revenue = Total production (tons) × 1000 × Price per kg
- Estimated costs = 40-60% of revenue (includes seeds, fertilizers, labor, irrigation)
- Use realistic cost percentages based on crop type

Return ONLY a JSON object in this exact format:
{
  "current_market_price": 25.00,
  "price_range": {"min": 20.00, "max": 30.00},
  "profit_analysis": {
    "total_revenue": 125000,
    "estimated_costs": 75000,
    "net_profit": 50000,
    "profit_per_hectare": 25000
  },
  "market_trends": "Brief market trends analysis",
  "selling_strategies": "Best selling strategies",
  "risk_factors": "Key market risks",
  "government_support": "MSP and government schemes info"
}

Use realistic Indian market prices for ${crop} in ${state}. All prices in ₹ per kg. Be specific and practical.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      try {
        String cleanText = responseText.trim();

        if (cleanText.startsWith('```json')) {
          cleanText = cleanText.replaceFirst('```json', '').trim();
        }
        if (cleanText.startsWith('```')) {
          cleanText = cleanText.replaceFirst('```', '').trim();
        }
        if (cleanText.endsWith('```')) {
          cleanText = cleanText.substring(0, cleanText.length - 3).trim();
        }

        final startIndex = cleanText.indexOf('{');
        final endIndex = cleanText.lastIndexOf('}') + 1;

        if (startIndex == -1 || endIndex == 0) {
          throw Exception('No JSON found in response');
        }

        final jsonString = cleanText.substring(startIndex, endIndex);

        final Map<String, dynamic> data = _parseSimpleJson(jsonString);

        if (!data.containsKey('current_market_price') ||
            !data.containsKey('profit_analysis')) {
          throw Exception('Missing required fields in response');
        }

        return data;
      } catch (parseError) {
        throw Exception('Failed to parse Gemini response as JSON');
      }
    } catch (e) {
      return {
        'current_market_price': 40.0,
        'price_range': {'min': 30.0, 'max': 50.0},
        'profit_analysis': {
          'total_revenue': (predictedYield * area * 40.0 * 1000)
              .roundToDouble(),
          'estimated_costs': (predictedYield * area * 20.0 * 1000)
              .roundToDouble(),
          'net_profit': (predictedYield * area * 20.0 * 1000).roundToDouble(),
          'profit_per_hectare': (predictedYield * 20.0 * 1000).roundToDouble(),
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

  Map<String, dynamic> _parseSimpleJson(String jsonString) {
    final Map<String, dynamic> result = {};

    try {
      String clean = jsonString.replaceAll(RegExp(r'\s+'), ' ');

      final priceMatch = RegExp(
        r'"current_market_price"\s*:\s*([0-9.]+)',
      ).firstMatch(clean);
      if (priceMatch != null) {
        result['current_market_price'] = double.parse(priceMatch.group(1)!);
      }

      final minMatch = RegExp(r'"min"\s*:\s*([0-9.]+)').firstMatch(clean);
      final maxMatch = RegExp(r'"max"\s*:\s*([0-9.]+)').firstMatch(clean);
      if (minMatch != null && maxMatch != null) {
        result['price_range'] = {
          'min': double.parse(minMatch.group(1)!),
          'max': double.parse(maxMatch.group(1)!),
        };
      }

      final revenueMatch = RegExp(
        r'"total_revenue"\s*:\s*([0-9.]+)',
      ).firstMatch(clean);
      final costsMatch = RegExp(
        r'"estimated_costs"\s*:\s*([0-9.]+)',
      ).firstMatch(clean);
      final profitMatch = RegExp(
        r'"net_profit"\s*:\s*([0-9.]+)',
      ).firstMatch(clean);
      final hectareMatch = RegExp(
        r'"profit_per_hectare"\s*:\s*([0-9.]+)',
      ).firstMatch(clean);

      if (revenueMatch != null &&
          costsMatch != null &&
          profitMatch != null &&
          hectareMatch != null) {
        result['profit_analysis'] = {
          'total_revenue': double.parse(revenueMatch.group(1)!),
          'estimated_costs': double.parse(costsMatch.group(1)!),
          'net_profit': double.parse(profitMatch.group(1)!),
          'profit_per_hectare': double.parse(hectareMatch.group(1)!),
        };
      }

      final stringFields = [
        'market_trends',
        'selling_strategies',
        'risk_factors',
        'government_support',
      ];
      for (final field in stringFields) {
        final match = RegExp('"$field"\\s*:\\s*"([^"]*)"').firstMatch(clean);
        if (match != null) {
          result[field] = match.group(1)!;
        }
      }
    } catch (e) {
      throw e;
    }

    return result;
  }

  Future<Map<String, dynamic>> generatePestInformation({
    required String pestName,
    String? userContext,
  }) async {
    try {
      final prompt =
          '''
You are an agricultural expert providing comprehensive information about the pest: "$pestName"

${userContext ?? ''}

Please provide detailed information in the following format as a JSON response:

{
  "pest_name": "$pestName",
  "scientific_name": "Scientific name of the pest",
  "description": "Brief description of the pest and its characteristics",
  "affected_crops": ["list", "of", "commonly", "affected", "crops"],
  "damage_symptoms": "Detailed description of damage symptoms and signs to look for",
  "lifecycle": "Brief description of pest lifecycle and behavior patterns",
  "prevention_methods": [
    "Cultural prevention method 1",
    "Cultural prevention method 2",
    "Biological prevention method with natural enemies"
  ],
  "organic_treatments": [
    "Organic treatment option 1 with specific application method and timing",
    "Organic treatment option 2 with dosage and frequency",
    "Natural remedy with preparation instructions and ingredients"
  ],
  "chemical_treatments": [
    "Chemical pesticide option 1 with specific brand names available in India and exact dosage",
    "Chemical pesticide option 2 with application method and safety measures",
    "Systemic treatment option with precautions and resistance management"
  ],
  "integrated_management": "Comprehensive IPM strategy combining multiple approaches",
  "timing": "Best timing for treatment application including crop stage and weather conditions",
  "precautions": "Detailed safety precautions, environmental considerations, and protective equipment needed",
  "economic_importance": "Economic impact, damage thresholds, and cost-benefit analysis of treatments",
  "monitoring_tips": "Specific monitoring techniques, scouting methods, and early detection signs",
  "local_recommendations": "Specific advice considering Indian farming conditions and available resources"
}

Focus on practical, actionable advice for Indian farmers. Include specific product names available in India, exact dosages, and step-by-step application methods. Be comprehensive yet easy to understand.

IMPORTANT: Return ONLY the JSON object, no additional text or formatting.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      print('[GEMINI] Pest response length: ${responseText.length} chars');
      print(
        '[GEMINI] Pest response preview: ${responseText.length > 200 ? responseText.substring(0, 200) + "..." : responseText}',
      );

      return _parsePestInformationResponse(responseText, pestName);
    } catch (e) {
      return {
        'pest_name': pestName,
        'description':
            'Unable to fetch detailed information at the moment. Error: $e. Please consult with local agricultural experts.',
        'error': true,
      };
    }
  }

  Map<String, dynamic> _parsePestInformationResponse(
    String response,
    String pestName,
  ) {
    try {
      String cleanResponse = response.trim();

      if (cleanResponse.startsWith('```json')) {
        cleanResponse = cleanResponse.replaceFirst('```json', '').trim();
      }
      if (cleanResponse.startsWith('```')) {
        cleanResponse = cleanResponse.replaceFirst('```', '').trim();
      }
      if (cleanResponse.endsWith('```')) {
        cleanResponse = cleanResponse
            .substring(0, cleanResponse.length - 3)
            .trim();
      }

      final startIndex = cleanResponse.indexOf('{');
      final endIndex = cleanResponse.lastIndexOf('}') + 1;

      if (startIndex == -1 || endIndex == 0) {
        throw Exception('No JSON found in response');
      }

      final jsonString = cleanResponse.substring(startIndex, endIndex);

      return _parseSimplePestJson(jsonString, pestName);
    } catch (e) {
      return {
        'pest_name': pestName,
        'description':
            'Unable to parse detailed pest information. Response parsing error: $e. Please consult with local agricultural experts.',
        'error': true,
      };
    }
  }

  Map<String, dynamic> _parseSimplePestJson(
    String jsonString,
    String pestName,
  ) {
    final Map<String, dynamic> result = {};

    try {
      final stringFields = [
        'pest_name',
        'scientific_name',
        'description',
        'damage_symptoms',
        'lifecycle',
        'integrated_management',
        'timing',
        'precautions',
        'economic_importance',
        'monitoring_tips',
        'local_recommendations',
      ];

      for (final field in stringFields) {
        final pattern = '"$field"\\s*:\\s*"([^"]*(?:\\\\.[^"]*)*)"';
        final match = RegExp(pattern, dotAll: true).firstMatch(jsonString);
        if (match != null) {
          result[field] =
              match.group(1)?.replaceAll(r'\"', '"').replaceAll(r'\\n', '\n') ??
              '';
        }
      }

      final arrayFields = [
        'affected_crops',
        'prevention_methods',
        'organic_treatments',
        'chemical_treatments',
      ];

      for (final field in arrayFields) {
        final pattern = '"$field"\\s*:\\s*\\[([^\\]]*(?:\\\\.[^\\]]*)*)\\]';
        final match = RegExp(pattern, dotAll: true).firstMatch(jsonString);
        if (match != null) {
          final arrayContent = match.group(1) ?? '';
          final items = arrayContent
              .split('",')
              .map((item) => item.replaceAll('"', '').trim())
              .where((item) => item.isNotEmpty)
              .toList();

          if (items.isNotEmpty) {
            items[items.length - 1] = items.last
                .replaceAll(RegExp(r'[^a-zA-Z0-9\s\-\(\)\.,%/:]'), '')
                .trim();
          }

          result[field] = items;
        }
      }

      if (!result.containsKey('pest_name') ||
          result['pest_name'].toString().isEmpty) {
        result['pest_name'] = pestName;
      }

      return result;
    } catch (e) {
      return {
        'pest_name': pestName,
        'description':
            'Error parsing pest information. Please consult with local agricultural experts.',
        'error': true,
      };
    }
  }
}
