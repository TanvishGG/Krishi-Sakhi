import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/eligibility_model.dart';
import '../services/onboarding_storage_service.dart';
import '../utils/env_keys.dart';

class SchemesLoansService {
  static String get _apiKey => EnvKeys.schemesLoansApiKey;

  late final GenerativeModel _model;
  final OnboardingStorageService _storageService = OnboardingStorageService();

  SchemesLoansService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
    );
  }

  Future<EligibilityResult> checkEligibility() async {
    try {
      final userData = await _storageService.getOnboardingData();

      final name = userData['name'] ?? 'Farmer';
      final locality = userData['locality'] ?? 'India';
      final landArea = userData['landArea'] ?? 'Not specified';
      final typesOfCrops = userData['typesOfCrops'] ?? 'Mixed crops';
      final fertilizersAndChemicals =
          userData['fertilizersAndChemicals'] ?? 'Standard';
      final sourceOfIrrigation = userData['sourceOfIrrigation'] ?? 'Rain-fed';
      final numberOfCrops = userData['numberOfCrops'] ?? '1-2 crops per year';

      final prompt =
          """
Act as a knowledgeable Government Scheme and Loan Advisor for Indian farmers. 
Based on the provided farmer details, provide detailed suggestions on relevant 
government schemes and agricultural loans. Focus on schemes and loans commonly 
available across India with special attention to the farmer's specific situation.

Farmer Profile:
- Name: $name
- Location: $locality
- Land Size: $landArea
- Primary Crops: $typesOfCrops
- Fertilizers/Chemicals Used: $fertilizersAndChemicals
- Irrigation Source: $sourceOfIrrigation
- Cropping Pattern: $numberOfCrops

Based on this profile, suggest:
1. The most relevant Central/State government scheme
2. The most suitable agricultural loan or financial product

Consider factors like:
- Land size for scheme eligibility
- Crop type for specialized schemes
- Irrigation needs for water/infrastructure schemes
- Financial assistance for inputs and equipment
- Insurance and risk mitigation schemes

Provide practical, actionable information that helps the farmer understand:
- What they might be eligible for
- What documents they need
- Where to apply
- Next steps to take

Output MUST be a JSON object that strictly follows this structure:
{
  "schemeSuggestion": "Name of the most relevant government scheme",
  "schemeEligibilityStatus": "Likely Eligible OR Potentially Eligible OR Need More Information",
  "schemeDescription": "Brief description of scheme benefits, subsidy amounts, and purpose",
  "schemeDocuments": "List of required documents for application",
  "loanSuggestion": "Most suitable agricultural loan or financial product",
  "loanEligibilityStatus": "Likely Eligible OR Potentially Eligible OR Need More Information", 
  "loanDescription": "Brief description of loan terms, interest rates, and benefits",
  "loanDocuments": "List of required documents for loan application",
  "officialDisclaimer": "Strong disclaimer about verifying with official sources",
  "nextSteps": ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5"]
}

Focus on schemes like:
- PM-KISAN (Direct Income Support)
- Pradhan Mantri Fasal Bima Yojana (Crop Insurance)
- Soil Health Card Scheme
- Pradhan Mantri Krishi Sinchayee Yojana (Irrigation)
- National Mission for Sustainable Agriculture
- Kisan Credit Card
- Agriculture Infrastructure Fund
- State-specific schemes

Focus on loans like:
- Kisan Credit Card (KCC)
- Crop Loans
- Farm Mechanization Loans
- Warehouse Receipt Financing
- Dairy/Livestock Loans
- Horticulture Loans
- Self Help Group Loans

Be specific about interest rates, subsidy percentages, and eligibility criteria commonly known for Indian agricultural schemes.
""";

      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        print('Empty response from Gemini API');
        throw Exception('Empty response from Gemini API');
      }

      final jsonData = _parseJsonResponse(responseText);

      final requiredFields = [
        'schemeSuggestion',
        'schemeEligibilityStatus',
        'schemeDescription',
        'schemeDocuments',
        'loanSuggestion',
        'loanEligibilityStatus',
        'loanDescription',
        'loanDocuments',
        'officialDisclaimer',
        'nextSteps',
      ];

      for (final field in requiredFields) {
        if (!jsonData.containsKey(field)) {
          print('Missing required field: $field');
          return _getFallbackResult();
        }
      }

      return EligibilityResult.fromJson(jsonData);
    } catch (e) {
      print('Schemes & Loans Service Error: $e');
      return _getFallbackResult();
    }
  }

  Map<String, dynamic> _parseJsonResponse(String responseText) {
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
        print('Raw response text: $responseText');
        throw Exception('No JSON found in response');
      }

      final jsonString = cleanText.substring(startIndex, endIndex);

      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      return jsonData;
    } catch (e) {
      print('JSON parsing error: $e');
      print('Response text that failed to parse: $responseText');
      throw Exception('Failed to parse response as JSON: $e');
    }
  }

  EligibilityResult _getFallbackResult() {
    return EligibilityResult(
      schemeSuggestion: 'PM-KISAN (Pradhan Mantri Kisan Samman Nidhi)',
      schemeEligibilityStatus: 'Likely Eligible',
      schemeDescription:
          'Direct income support of ₹6,000 per year in three installments for small and marginal farmers with cultivable land.',
      schemeDocuments:
          'Aadhaar Card, Bank Account Details, Land Records (Khata/Khesra), Passport Size Photo',
      loanSuggestion: 'Kisan Credit Card (KCC)',
      loanEligibilityStatus: 'Likely Eligible',
      loanDescription:
          'Flexible credit facility for farmers with interest rate around 7% (after government subsidy). Covers crop loans, farm expenses, and allied activities.',
      loanDocuments:
          'Aadhaar Card, PAN Card, Bank Account Statement, Land Records, Income Certificate, Passport Size Photos',
      officialDisclaimer:
          'This is a preliminary assessment only. Please verify eligibility criteria and application procedures with official government websites, local agricultural offices, or authorized bank branches.',
      nextSteps: [
        'Visit your nearest Common Service Center (CSC) or bank branch',
        'Collect and organize all required documents',
        'Check the official PM-KISAN portal: pmkisan.gov.in',
        'Contact your local Agricultural Extension Officer',
        'Apply for Kisan Credit Card at your preferred bank',
      ],
    );
  }
}
