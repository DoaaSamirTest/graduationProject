import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = 'http://192.168.218.190:5000';

  static Future<Map<String, dynamic>> sendWordToServer(String word) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/set_class'), body: {'class_name': word})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          return {
            'success': true,
            'message': jsonResponse['message'] ?? 'Word sent successfully',
            'data': jsonResponse,
          };
        } catch (e) {
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

  static Future<Map<String, dynamic>> sendTestWord() async {
    return await sendWordToServer('test_word');
  }

  static Future<Map<String, dynamic>> sendCustomWord(String customWord) async {
    return await sendWordToServer(customWord);
  }

  static Future<Map<String, dynamic>> sendMedicineName(
    String medicineName,
  ) async {
    return await sendWordToServer(medicineName);
  }
}
