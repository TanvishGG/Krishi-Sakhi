import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  final GeminiService _geminiService = GeminiService();

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> sendMessage(String text, BuildContext context) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    _messages.add(userMessage);
    notifyListeners();

    final index = _messages.indexWhere((msg) => msg.id == userMessage.id);
    if (index != -1) {
      _messages[index] = userMessage.copyWith(status: MessageStatus.sent);
      notifyListeners();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _callChatApi(text, context);

      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.delivered,
      );

      _messages.add(botMessage);
    } catch (e) {
      _errorMessage = 'Failed to send message: $e';

      final failedIndex = _messages.indexWhere(
        (msg) => msg.id == userMessage.id,
      );
      if (failedIndex != -1) {
        _messages[failedIndex] = userMessage.copyWith(
          status: MessageStatus.failed,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _callChatApi(String message, BuildContext context) async {
    try {
      final recentMessages = _messages
          .take(5)
          .where((msg) => !msg.isUser)
          .map((msg) => msg.text)
          .join('\n');
      final context = recentMessages.isNotEmpty
          ? 'Recent conversation:\n$recentMessages'
          : null;

      final response = await _geminiService.generateResponse(
        message,
        context: context,
      );

      return response;
    } catch (e) {
      print('Chat API Error: $e');
      return _getFallbackResponse(message);
    }
  }

  String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('crop') || lowerMessage.contains('farming')) {
      return 'I can help you with crop management and farming techniques. What specific crop are you growing?';
    } else if (lowerMessage.contains('weather')) {
      return 'Weather is crucial for farming. I recommend checking local weather forecasts and planning your activities accordingly.';
    } else if (lowerMessage.contains('pest') ||
        lowerMessage.contains('disease')) {
      return 'Pest and disease management is important. Can you describe the symptoms you\'re seeing on your crops?';
    } else if (lowerMessage.contains('water') ||
        lowerMessage.contains('irrigation')) {
      return 'Proper irrigation is key to healthy crops. Consider drip irrigation for water efficiency.';
    } else if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello! I\'m Krishi Sakhi, your agricultural assistant. How can I help you with your farming needs today?';
    } else {
      return 'Thank you for your question. As an agricultural assistant, I\'m here to help with farming, crops, irrigation, pest management, and other agricultural topics. Could you please provide more details about your farming question?';
    }
  }

  void retryMessage(String messageId, BuildContext context) {
    final message = _messages.firstWhere((msg) => msg.id == messageId);
    if (message.isUser && message.status == MessageStatus.failed) {
      sendMessage(message.text, context);
    }
  }

  void clearMessages() {
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void addWelcomeMessage() {
    if (_messages.isEmpty) {
      final welcomeMessage = ChatMessage(
        id: 'welcome',
        text:
            'Hello! I\'m Krishi Sakhi, your agricultural assistant. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.delivered,
      );
      _messages.add(welcomeMessage);
      notifyListeners();
    }
  }
}
