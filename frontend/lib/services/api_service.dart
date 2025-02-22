// frontend/lib/services/api_service.dart

import '../models/sentiment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use localhost for local development
  static const String baseUrl = 'http://localhost:8000';
  
  Future<Sentiment> analyzeText(String text) async {
    try {
      // Add error logging to see what's happening
      print('Sending request to: $baseUrl/analyze');
      final response = await http.post(
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

      final Map<String, dynamic> data = jsonDecode(response.body);
      
      // Handle loading state
      if (data['sentiment'] == 'LOADING') {
        // Wait a bit and retry
        await Future.delayed(Duration(seconds: 2));
        return analyzeText(text);  // Recursive retry
      }

      return Sentiment.fromJson(data);
    } catch (e) {
      print('Detailed error: $e');
      throw Exception('Failed to analyze sentiment');
    }
  }
}