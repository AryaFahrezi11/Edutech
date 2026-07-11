import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '/config/api_endpoints.dart';

class GeminiService extends GetxService {
  Future<GeminiService> init() async {
    return this;
  }

  /// Mengevaluasi tulisan anak dan mengembalikan JSON berisi feedback suara dan data analitik
  Future<Map<String, dynamic>?> evaluateWriting({
    required String targetWord,
    required String writtenWord,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.evaluateAi);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "targetWord": targetWord,
          "inputWord": writtenWord,
          "mode": "writing"
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Error Evaluate AI (Writing): ${response.body}");
      }
    } catch (e) {
      print("❌ Error Exception Evaluate AI: $e");
    }
    return null;
  }

  /// Mengevaluasi ejaan lisan anak (Speech-to-Text) dan mengembalikan JSON berisi feedback suara dan data analitik
  Future<Map<String, dynamic>?> evaluateSpelling({
    required String targetWord,
    required String spokenWord,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.evaluateAi);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "targetWord": targetWord,
          "inputWord": spokenWord,
          "mode": "spelling"
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Error Evaluate AI (Spelling): ${response.body}");
      }
    } catch (e) {
      print("❌ Error Exception Evaluate AI: $e");
    }
    return null;
  }
}
