import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'http_service.dart';

class HttpTestService {
  /// Sends a test HTTP request to the Flask server
  static Future<void> sendHttpTest(BuildContext context) async {
    try {
      _showToast("Sending HTTP request...");
      final result = await HttpService.sendTestWord();

      if (result['success']) {
        _showToast("HTTP Success: ${result['message']}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إرسال الطلب بنجاح: ${result['message']}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _showToast("HTTP Error: ${result['message']}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في الإرسال: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      _showToast("HTTP Exception: ${e.toString()}");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الإرسال: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Sends a medicine name to the server
  static Future<void> sendMedicineNameToServer(
    BuildContext context,
    String medicineName,
  ) async {
    try {
      _showToast("Sending medicine name: $medicineName");
      final result = await HttpService.sendMedicineName(medicineName);

      if (result['success']) {
        _showToast("Medicine sent successfully: ${result['message']}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إرسال اسم الدواء بنجاح: ${result['message']}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _showToast("HTTP Error: ${result['message']}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في إرسال اسم الدواء: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      _showToast("HTTP Exception: ${e.toString()}");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إرسال اسم الدواء: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Shows a toast message.
  static void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }
}
