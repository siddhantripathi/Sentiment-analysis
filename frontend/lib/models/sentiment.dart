class Sentiment {
  final String emotion;
  final double confidence;
  final String emoji;

  Sentiment({
    required this.emotion,
    required this.confidence,
  }) : emoji = _getEmoji(emotion);

  factory Sentiment.fromJson(Map<String, dynamic> json) {
    return Sentiment(
      emotion: json['emotion'] ?? 'NEUTRAL',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }

  static String _getEmoji(String emotion) {
    switch (emotion.toUpperCase()) {
      case 'JOY':
        return '😀';
      case 'SADNESS':
        return '😭';
      case 'ANGER':
        return '🤬';
      case 'FEAR':
        return '😨';
      case 'DISGUST':
        return '🤢';
      case 'SURPRISE':
        return '😲';
      case 'NEUTRAL':
      default:
        return '😐';
    }
  }
}