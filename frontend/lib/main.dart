import 'package:flutter/material.dart';
import 'models/sentiment.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentiment Analysis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sentiment Analysis'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  Sentiment? _result;
  bool _isLoading = false;

  Color _getSentimentColor(String emotion) {
    switch (emotion.toUpperCase()) {
      case 'JOY':
        return Colors.yellow;
      case 'SADNESS':
        return Colors.blue;
      case 'ANGER':
        return Colors.red;
      case 'FEAR':
        return Colors.purple;
      case 'DISGUST':
        return Colors.green;
      case 'SURPRISE':
        return Colors.orange;
      case 'NEUTRAL':
      default:
        return Colors.grey;
    }
  }

  Widget _buildResult() {
    if (_result == null) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _result!.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            Text(
              'Emotion: ${_result!.emotion.toLowerCase()}',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
            Text(
              'Confidence: ${(_result!.confidence * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 18,
                color: _getSentimentColor(_result!.emotion),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter text to analyze',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _analyzeText,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Analyze'),
            ),
            _buildResult(),
          ],
        ),
      ),
    );
  }

  Future<void> _analyzeText() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.analyzeText(_controller.text);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
