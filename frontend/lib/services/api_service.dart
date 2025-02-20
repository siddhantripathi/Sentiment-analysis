// frontend/lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sentiment.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8000';//localhost:8000';
Future<Sentiment> analyzeText(String text) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/analyze'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }
      return Sentiment.fromJson(jsonResponse);
    } else {
      throw Exception('Failed with status: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on FormatException {
    throw Exception('Invalid JSON format');
  }
}
}