import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/crop_api_service.dart';
import '../services/gemini_service.dart';
import '../services/onboarding_storage_service.dart';

class PestDetectionProvider with ChangeNotifier {
  final CropApiService _apiService = CropApiService();
  final GeminiService _geminiService = GeminiService();
  final OnboardingStorageService _storageService = OnboardingStorageService();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoading = false;
  bool _isLoadingPestInfo = false;
  String? _errorMessage;
  String? _detectedPest;
  double? _confidence;
  File? _selectedImage;
  Map<String, dynamic>? _pestInformation;

  bool get isLoading => _isLoading;
  bool get isLoadingPestInfo => _isLoadingPestInfo;
  String? get errorMessage => _errorMessage;
  String? get detectedPest => _detectedPest;
  double? get confidence => _confidence;
  File? get selectedImage => _selectedImage;
  Map<String, dynamic>? get pestInformation => _pestInformation;

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        clearResults();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  Future<void> detectPest() async {
    if (_selectedImage == null) {
      _errorMessage = 'Please select an image first';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _detectedPest = null;
    _confidence = null;
    _pestInformation = null;
    notifyListeners();

    try {
      final response = await _apiService.predictPest(_selectedImage!);
      _detectedPest = response['pest'];
      _confidence = response['confidence'];

      if (_detectedPest != null && _detectedPest!.isNotEmpty) {
        await _getPestInformationFromGemini(_detectedPest!);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getPestInformationFromGemini(String pestName) async {
    _isLoadingPestInfo = true;
    notifyListeners();

    try {
      final userData = await _storageService.getOnboardingData();
      print('Retrieved user data: ${userData.isNotEmpty ? 'Yes' : 'No'}');

      print('Calling Gemini service for pest: $pestName');

      final basicPrompt =
          '''
Please provide comprehensive information about the pest: "$pestName" in JSON format:

{
  "pest_name": "$pestName",
  "description": "Brief description of the pest",
  "affected_crops": ["crop1", "crop2"],
  "organic_treatments": ["treatment1", "treatment2"],
  "chemical_treatments": ["treatment1", "treatment2"]
}

Return only the JSON object.
''';

      final basicResponse = await _geminiService.generateResponse(basicPrompt);
      print(
        'Basic response received: ${basicResponse.substring(0, basicResponse.length > 200 ? 200 : basicResponse.length)}...',
      );

      _pestInformation = _parseBasicPestResponse(basicResponse, pestName);
    } catch (e) {
      print('Error getting pest information from Gemini: $e');
      print('Exception type: ${e.runtimeType}');
      _pestInformation = {
        'pest_name': pestName,
        'description':
            'Unable to fetch detailed information at the moment. Error: $e. Please consult with local agricultural experts.',
        'error': true,
      };
    } finally {
      _isLoadingPestInfo = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _detectedPest = null;
    _confidence = null;
    _errorMessage = null;
    _pestInformation = null;
    notifyListeners();
  }

  void clearImage() {
    _selectedImage = null;
    clearResults();
  }

  Map<String, dynamic> _parseBasicPestResponse(
    String response,
    String pestName,
  ) {
    try {
      print('Raw response length: ${response.length}');
      print(
        'Raw response (first 300 chars): ${response.length > 300 ? response.substring(0, 300) + "..." : response}',
      );

      if (!response.contains('{') || !response.contains('}')) {
        print('No JSON structure found, parsing as text');
        return _parseTextResponse(response, pestName);
      }

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
        print('No valid JSON bounds found');
        return _parseTextResponse(response, pestName);
      }

      final jsonString = cleanResponse.substring(startIndex, endIndex);
      print(
        'Extracted JSON: ${jsonString.length > 200 ? jsonString.substring(0, 200) + "..." : jsonString}',
      );

      final Map<String, dynamic> result = {};
      result['pest_name'] = pestName;

      final descPattern = RegExp(
        r'"description"\s*:\s*"([^"]*(?:\\.[^"]*)*)"',
        dotAll: true,
      );
      final descMatch = descPattern.firstMatch(jsonString);
      if (descMatch != null) {
        result['description'] =
            descMatch.group(1)?.replaceAll(r'\"', '"') ??
            'Pest information available';
        print('Found description: ${result['description']}');
      } else {
        result['description'] = _extractDescriptionFromText(response, pestName);
      }

      final cropPattern = RegExp(
        r'"affected_crops"\s*:\s*\[(.*?)\]',
        dotAll: true,
      );
      final cropMatch = cropPattern.firstMatch(jsonString);
      if (cropMatch != null) {
        final cropStr = cropMatch.group(1) ?? '';
        final crops = cropStr
            .split(',')
            .map((c) => c.replaceAll(RegExp(r'["\[\]]'), '').trim())
            .where((c) => c.isNotEmpty)
            .toList();
        result['affected_crops'] = crops;
        print('Found crops: $crops');
      }

      final organicPattern = RegExp(
        r'"organic_treatments"\s*:\s*\[(.*?)\]',
        dotAll: true,
      );
      final organicMatch = organicPattern.firstMatch(jsonString);
      if (organicMatch != null) {
        final organicStr = organicMatch.group(1) ?? '';
        final treatments = organicStr
            .split('",')
            .map((t) => t.replaceAll(RegExp(r'["\[\]]'), '').trim())
            .where((t) => t.isNotEmpty)
            .toList();
        result['organic_treatments'] = treatments;
        print('Found organic treatments: $treatments');
      }

      final chemicalPattern = RegExp(
        r'"chemical_treatments"\s*:\s*\[(.*?)\]',
        dotAll: true,
      );
      final chemicalMatch = chemicalPattern.firstMatch(jsonString);
      if (chemicalMatch != null) {
        final chemicalStr = chemicalMatch.group(1) ?? '';
        final treatments = chemicalStr
            .split('",')
            .map((t) => t.replaceAll(RegExp(r'["\[\]]'), '').trim())
            .where((t) => t.isNotEmpty)
            .toList();
        result['chemical_treatments'] = treatments;
        print('Found chemical treatments: $treatments');
      }

      print('Successfully parsed pest information');
      return result;
    } catch (e) {
      print('Error parsing pest response: $e');
      return _parseTextResponse(response, pestName);
    }
  }

  Map<String, dynamic> _parseTextResponse(String response, String pestName) {
    print('Parsing as text response');

    String description = _extractDescriptionFromText(response, pestName);

    return {
      'pest_name': pestName,
      'description': description,
      'affected_crops': [
        'Rice',
        'Wheat',
        'Cotton',
        'Vegetables',
        'Various crops',
      ],
      'organic_treatments': [
        'Neem oil spray (5ml per liter of water)',
        'Bacillus thuringiensis (Bt) application',
        'Beneficial insects like ladybugs and lacewings',
        'Cultural practices like crop rotation',
      ],
      'chemical_treatments': [
        'Consult local agricultural store for appropriate pesticides',
        'Follow recommended dosage and safety guidelines',
        'Apply during early morning or evening hours',
        'Use protective equipment during application',
      ],
      'prevention_methods': [
        'Regular field monitoring and scouting',
        'Maintain field hygiene and remove crop debris',
        'Use resistant varieties when available',
        'Proper water management',
      ],
      'timing':
          'Apply treatments during early infestation stages for best results',
      'precautions':
          'Always wear protective equipment and follow label instructions',
    };
  }

  String _extractDescriptionFromText(String response, String pestName) {
    if (response.toLowerCase().contains(pestName.toLowerCase())) {
      final sentences = response.split(RegExp(r'[.!?]+'));
      for (final sentence in sentences) {
        if (sentence.toLowerCase().contains(pestName.toLowerCase()) &&
            sentence.length > 20) {
          return sentence.trim() + '.';
        }
      }
    }

    final sentences = response.split(RegExp(r'[.!?]+'));
    for (final sentence in sentences) {
      if (sentence.length > 30 &&
          !sentence.contains('{') &&
          !sentence.contains('}')) {
        return sentence.trim() + '.';
      }
    }

    return '$pestName is a common agricultural pest that can cause significant damage to crops. Integrated pest management approaches combining cultural, biological, and chemical methods are recommended for effective control.';
  }

  Future<void> refreshPestInformation() async {
    if (_detectedPest != null && _detectedPest!.isNotEmpty) {
      await _getPestInformationFromGemini(_detectedPest!);
    }
  }
}
