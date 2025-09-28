import 'dart:convert';
import 'package:http/http.dart' as http;

class AgriBuddyApiService {
  static const String _baseUrl = 'https://tunnel-8000.tanvish.co.in/';

  Future<Map<String, dynamic>> converse({
    required String sessionId,
    required String farmerText,
    required String lang,
    String? crop,
    String? diseaseName,
    double? diseaseConfidence,
    List<Map<String, dynamic>>? history,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/converse');

      final body = {
        'session_id': sessionId,
        'farmer_text': farmerText,
        'lang': lang,
        if (crop != null) 'crop': crop,
        if (diseaseName != null) 'disease_name': diseaseName,
        if (diseaseConfidence != null) 'disease_confidence': diseaseConfidence,
        if (history != null && history.isNotEmpty) 'history': history,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> healthCheck() async {
    try {
      final url = Uri.parse('$_baseUrl/health');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ok'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  List<Map<String, dynamic>> convertChatHistory(
    List<Map<String, dynamic>> chatMessages,
  ) {
    return chatMessages.map((message) {
      return {
        'role': message['isUser'] == true ? 'farmer' : 'assistant',
        'text': message['text'] ?? '',
        'meta': {
          'timestamp': message['timestamp'] ?? DateTime.now().toIso8601String(),
        },
      };
    }).toList();
  }
}
