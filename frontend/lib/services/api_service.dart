// frontend/lib/services/api_service.dart

import '../models/sentiment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use localhost for local development
  final String baseUrl = 'http://localhost:8000';
  final _client = http.Client();
  
  Future<Sentiment> analyzeText(String text) async {
    try {
      // Add error logging to see what's happening
      print('Sending request to: $baseUrl/analyze');
      final response = await _client.post(
        Uri.parse('$baseUrl/analyze'),  // No /api prefix for local development
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'text': text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Sentiment.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('Detailed error: $e');
      throw Exception('Failed to analyze text: $e');
    }
  }
}