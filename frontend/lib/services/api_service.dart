// frontend/lib/services/api_service.dart

import '../models/sentiment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Try the newer Vercel URL
  static const String baseUrl = 'https://sentiment-analysis-puocpossn-siddhantripathis-projects.vercel.app';
  
  Future<Sentiment> analyzeText(String text) async {
    try {
      // Add error logging to see what's happening
      print('Sending request to: $baseUrl/api/analyze');
      final response = await http.post(
        Uri.parse('$baseUrl/api/analyze'),
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
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Sentiment.fromJson(data);
      } else {
        throw Exception('Failed to analyze sentiment: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Detailed error: $e');
      throw Exception('Failed to analyze sentiment');
    }
  }
}