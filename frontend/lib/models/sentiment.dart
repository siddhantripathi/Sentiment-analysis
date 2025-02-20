class Sentiment {
  final String sentiment;
  final double confidence;
  final String emoji;

  Sentiment({
    required this.sentiment,
    required this.confidence,
    required this.emoji,
  });

  factory Sentiment.fromJson(Map<String, dynamic> json) {
    return Sentiment(
      sentiment: json['sentiment'] ?? 'NEUTRAL',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      emoji: _getEmoji(json['sentiment']?.toString().toUpperCase() ?? 'NEUTRAL'),
    );
  }

  static String _getEmoji(String sentiment) {
    switch (sentiment) {
      case 'POSITIVE':
        return '😊';
      case 'NEGATIVE':
        return '😠';
      case 'NEUTRAL':
      default:
        return '😐';
    }
  }
}