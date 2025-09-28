import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/voice_models.dart';
import '../utils/constants.dart';
import '../services/gemini_service.dart';

class VoiceProvider with ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final GeminiService _geminiService = GeminiService();

  VoiceState _voiceState = VoiceState.idle;
  VoiceTranscription? _currentTranscription;
  List<VoiceTranscription> _transcriptionHistory = [];
  RecognitionError _lastError = RecognitionError.none;
  bool _isInitialized = false;
  bool _hasMicrophonePermission = false;
  String _currentLocale = AppConstants.localeEnglish;
  String? _currentSpeakingResponse;

  int _recordingDuration = 0;

  VoiceState get voiceState => _voiceState;
  VoiceTranscription? get currentTranscription => _currentTranscription;
  List<VoiceTranscription> get transcriptionHistory => _transcriptionHistory;
  RecognitionError get lastError => _lastError;
  bool get isInitialized => _isInitialized;
  bool get hasMicrophonePermission => _hasMicrophonePermission;
  bool get isListening => _voiceState == VoiceState.listening;
  bool get isSpeaking => _voiceState == VoiceState.speaking;
  bool get isRecording => _voiceState == VoiceState.listening;
  String get currentLocale => _currentLocale;
  String get transcription => _currentTranscription?.text ?? '';
  int get recordingDuration => _recordingDuration;
  String? get currentSpeakingResponse => _currentSpeakingResponse;

  Future<void> initialize() async {
    try {
      _voiceState = VoiceState.processing;
      notifyListeners();

      await _checkMicrophonePermission();

      if (!_hasMicrophonePermission) {
        _lastError = RecognitionError.noPermission;
        _voiceState = VoiceState.error;
        notifyListeners();
        return;
      }

      bool speechAvailable = await _speechToText.initialize(
        onError: _onSpeechError,
        onStatus: _onSpeechStatus,
      );

      if (!speechAvailable) {
        _lastError = RecognitionError.notAvailable;
        _voiceState = VoiceState.error;
        notifyListeners();
        return;
      }

      await _initializeTts();

      _isInitialized = true;
      _voiceState = VoiceState.idle;
      _lastError = RecognitionError.none;
    } catch (e) {
      debugPrint('Voice initialization error: $e');
      _lastError = RecognitionError.unknown;
      _voiceState = VoiceState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      _hasMicrophonePermission = result.isGranted;
    } else {
      _hasMicrophonePermission = status.isGranted;
    }
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    debugPrint('🔊 TTS initialized with English (en-US)');

    _flutterTts.setStartHandler(() {
      _voiceState = VoiceState.speaking;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      if (_voiceState == VoiceState.speaking) {
        _voiceState = VoiceState.idle;
        _currentSpeakingResponse = null;
        notifyListeners();
      }
    });

    _flutterTts.setErrorHandler((msg) {
      debugPrint('TTS Error: $msg');
      _voiceState = VoiceState.idle;
      notifyListeners();
    });
  }

  Future<void> startListening({String? locale}) async {
    if (!_isInitialized || !_hasMicrophonePermission) {
      await initialize();
      if (!_isInitialized) return;
    }

    if (_voiceState == VoiceState.listening) return;

    try {
      debugPrint('🎤 Starting to listen...');

      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 2),
        partialResults: true,
        localeId: 'en_US',
        listenMode: ListenMode.confirmation,
      );

      _voiceState = VoiceState.listening;
      _lastError = RecognitionError.none;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error starting speech recognition: $e');
      _lastError = RecognitionError.unknown;
      _voiceState = VoiceState.error;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    if (_voiceState == VoiceState.listening) {
      await _speechToText.stop();
      _voiceState = VoiceState.idle;
      notifyListeners();
    }
  }

  Future<void> speak(String text, {String? language}) async {
    if (_voiceState == VoiceState.speaking) {
      await _flutterTts.stop();
    }

    try {
      if (language != null) {
        await _flutterTts.setLanguage(language);
      }

      _voiceState = VoiceState.processing;
      notifyListeners();

      final context = _transcriptionHistory.isNotEmpty
          ? _transcriptionHistory.take(3).map((t) => t.text).join(' ')
          : null;

      final response = await _geminiService.generateVoiceResponse(
        text,
        context: context,
      );

      _voiceState = VoiceState.speaking;
      notifyListeners();

      await _flutterTts.speak(response);
    } catch (e) {
      debugPrint('Error in Gemini speak: $e');
      _voiceState = VoiceState.error;
      notifyListeners();

      try {
        await _flutterTts.speak(text);
      } catch (fallbackError) {
        debugPrint('Fallback speak error: $fallbackError');
      }
    }
  }

  Future<void> interruptAndSpeak(String text) async {
    if (_voiceState == VoiceState.speaking) {
      await _flutterTts.stop();
      _currentSpeakingResponse = null;
    }
    if (_voiceState == VoiceState.listening) {
      await _speechToText.stop();
    }

    _voiceState = VoiceState.idle;
    notifyListeners();

    if (text.trim().isEmpty) {
      await startListening();
    } else {
      await _speakSimple(text);
    }
  }

  void setLocale(String locale) {
    _currentLocale = locale;
    _initializeTts();
  }

  void clearTranscriptions() {
    _transcriptionHistory.clear();
    _currentTranscription = null;
    notifyListeners();
  }

  Future<void> startRecording(String language) async {
    await startListening(locale: language);
  }

  Future<void> stopRecording() async {
    if (_voiceState == VoiceState.listening) {
      await _speechToText.stop();
      _voiceState = VoiceState.idle;
      notifyListeners();
    }
  }

  Future<void> stopConversation() async {
    if (_voiceState == VoiceState.speaking) {
      await _flutterTts.stop();
      _currentSpeakingResponse = null;
    }
    if (_voiceState == VoiceState.listening) {
      await _speechToText.stop();
    }
    _voiceState = VoiceState.idle;
    notifyListeners();
  }

  void pauseRecording() {}

  void endRecording() {}

  void _onSpeechResult(result) async {
    final transcription = VoiceTranscription(
      text: result.recognizedWords,
      confidence: result.confidence,
      timestamp: DateTime.now(),
      locale: 'en_US',
      isFinal: result.finalResult,
    );

    _currentTranscription = transcription;

    debugPrint(
      '🎤 Speech result: "${transcription.text}" (confidence: ${transcription.confidence}, final: ${result.finalResult})',
    );

    if (result.finalResult && transcription.text.trim().isNotEmpty) {
      _transcriptionHistory.add(transcription);

      if (transcription.confidence >= 0.1 || transcription.text.length > 2) {
        debugPrint('✅ Processing transcription: "${transcription.text}"');
        await _autoRespond(transcription.text);
      } else {
        debugPrint('⚠️ Low confidence, asking for retry');
        await _speakSimple(
          'I\'m sorry, I couldn\'t understand that clearly. Could you try again?',
        );
      }
    }

    notifyListeners();
  }

  Future<void> _speakSimple(String text) async {
    try {
      _voiceState = VoiceState.speaking;
      _currentSpeakingResponse = text;
      notifyListeners();

      await _flutterTts.setLanguage('en-US');
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('❌ Error in simple speak: $e');
      _voiceState = VoiceState.idle;
      notifyListeners();
    }
  }

  Future<void> _autoRespond(String userText) async {
    try {
      debugPrint('🎯 Auto-responding to: "$userText"');
      _voiceState = VoiceState.processing;
      notifyListeners();

      final response = await _geminiService.generateVoiceResponse(userText);

      debugPrint(
        '📱 Got response: ${response.substring(0, response.length > 50 ? 50 : response.length)}...',
      );

      final aiTranscription = VoiceTranscription(
        text: response,
        confidence: 1.0,
        timestamp: DateTime.now(),
        locale: 'en_US',
        isFinal: true,
        type: TranscriptionType.ai,
      );
      _transcriptionHistory.add(aiTranscription);

      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);

      _voiceState = VoiceState.speaking;
      _currentSpeakingResponse = response;
      notifyListeners();

      debugPrint('🔊 Speaking response...');
      await _flutterTts.speak(response);
    } catch (e) {
      debugPrint('❌ Error in auto respond: $e');
      _voiceState = VoiceState.error;
      notifyListeners();

      final fallbackText =
          'I\'m sorry, I\'m having trouble responding right now. Please try asking again.';

      final fallbackTranscription = VoiceTranscription(
        text: fallbackText,
        confidence: 1.0,
        timestamp: DateTime.now(),
        locale: 'en_US',
        isFinal: true,
        type: TranscriptionType.ai,
      );
      _transcriptionHistory.add(fallbackTranscription);

      await _flutterTts.speak(fallbackText);
    }
  }

  void _onSpeechError(error) {
    debugPrint('Speech recognition error: $error');

    switch (error.errorMsg) {
      case 'error_no_match':
        _lastError = RecognitionError.none;
        break;
      case 'error_network':
        _lastError = RecognitionError.networkError;
        break;
      case 'error_speech_timeout':
        _lastError = RecognitionError.timeout;
        break;
      default:
        _lastError = RecognitionError.unknown;
    }

    _voiceState = _lastError == RecognitionError.none
        ? VoiceState.idle
        : VoiceState.error;
    notifyListeners();
  }

  void _onSpeechStatus(status) {
    debugPrint('Speech status: $status');

    switch (status) {
      case 'listening':
        _voiceState = VoiceState.listening;
        break;
      case 'notListening':
        _voiceState = VoiceState.idle;
        break;
      case 'done':
        _voiceState = VoiceState.idle;
        break;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }
}
