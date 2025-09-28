class VoiceTranscription {
  final String text;
  final double confidence;
  final DateTime timestamp;
  final String locale;
  final bool isFinal;
  final TranscriptionType type;

  const VoiceTranscription({
    required this.text,
    required this.confidence,
    required this.timestamp,
    required this.locale,
    this.isFinal = false,
    this.type = TranscriptionType.user,
  });

  VoiceTranscription copyWith({
    String? text,
    double? confidence,
    DateTime? timestamp,
    String? locale,
    bool? isFinal,
    TranscriptionType? type,
  }) {
    return VoiceTranscription(
      text: text ?? this.text,
      confidence: confidence ?? this.confidence,
      timestamp: timestamp ?? this.timestamp,
      locale: locale ?? this.locale,
      isFinal: isFinal ?? this.isFinal,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'VoiceTranscription(text: $text, confidence: $confidence, isFinal: $isFinal, type: $type)';
  }
}

enum TranscriptionType { user, ai }

enum VoiceState { idle, listening, processing, speaking, error }

enum RecognitionError {
  none,
  noPermission,
  notAvailable,
  networkError,
  timeout,
  unknown,
}
