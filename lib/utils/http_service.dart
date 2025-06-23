import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = 'http://192.168.1.2:5000';

  /// Sends a GET request to the Flask server with a word parameter
  /// Returns a Map with 'success' boolean and 'message' string
  static Future<Map<String, dynamic>> sendWordToServer(String word) async {
    try {
      final Uri uri = Uri.parse(
        '$baseUrl/receive',
      ).replace(queryParameters: {'word': word});

      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        // Try to parse JSON response if available
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          return {
            'success': true,
            'message': jsonResponse['message'] ?? 'Word sent successfully',
            'data': jsonResponse,
          };
        } catch (e) {
          // If response is not JSON, return the raw response
          return {
            'success': true,
            'message': 'Word sent successfully',
            'data': response.body,
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'data': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': null,
      };
    }
  }

  /// Sends a test word to the server
  static Future<Map<String, dynamic>> sendTestWord() async {
    return await sendWordToServer('test_word');
  }

  /// Sends a custom word to the server
  static Future<Map<String, dynamic>> sendCustomWord(String customWord) async {
    return await sendWordToServer(customWord);
  }

  /// Sends a medicine name to the server
  static Future<Map<String, dynamic>> sendMedicineName(
    String medicineName,
  ) async {
    return await sendWordToServer(medicineName);
  }
}
