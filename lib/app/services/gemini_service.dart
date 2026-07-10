import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService extends GetxService {
  // TODO: Masukkan API Key Gemini di sini atau ambil dari .env
  static const String _apiKey = 'API_KEY_GEMINI_ANDA_DISINI'; 

  late GenerativeModel _model;

  Future<GeminiService> init() async {
    // Kita gunakan gemini-1.5-flash untuk respon yang lebih cepat, cocok untuk game
    _model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: _apiKey,
      // Memaksa model untuk membalas dengan format JSON
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );
    return this;
  }

  /// Mengevaluasi tulisan anak dan mengembalikan JSON berisi feedback suara dan data analitik
  Future<Map<String, dynamic>?> evaluateWriting({
    required String targetWord,
    required String writtenWord,
  }) async {
    // Jika belum mengatur API Key, return null atau beri respons palsu untuk testing
    if (_apiKey == 'API_KEY_GEMINI_ANDA_DISINI' || _apiKey.isEmpty) {
      print("⚠️ Peringatan: API Key Gemini belum diatur!");
      return null;
    }

    try {
      final prompt = '''
Kamu adalah guru TK yang sedang mengevaluasi ujian menulis anak berusia 5-7 tahun.
Anak diminta menulis huruf atau kata: "$targetWord".
Namun, AI pembaca tulisan membaca tulisan anak tersebut sebagai: "$writtenWord".

Tugasmu:
1. Buat "voice_feedback" berupa kalimat penyemangat singkat dalam Bahasa Indonesia. Jika tulisannya salah total atau ada huruf yang tertukar, beritahu huruf apa yang salah dengan bahasa yang sangat lembut dan ceria (Maksimal 2 kalimat). Jika sudah lumayan mirip, puji dia.
2. Buat "analytics_data" untuk laporan orang tua (Big Data). Tentukan huruf apa saja yang kemungkinan salah ditulis (wrong_letters), jenis kesalahannya (error_type: "kesalahan_bentuk", "typo", "tidak_terbaca"), dan berikan estimasi accuracy_score (0-100).

Kembalikan WAJIB dalam format JSON yang valid persis seperti skema berikut ini:
{
  "voice_feedback": "Wah hampir benar! Tapi coba perhatikan lagi huruf depannya...",
  "analytics_data": {
    "target_word": "$targetWord",
    "written_word": "$writtenWord",
    "wrong_letters": ["huruf yang salah"],
    "error_type": "kesalahan_bentuk",
    "accuracy_score": 70
  }
}
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      if (response.text != null) {
        String rawText = response.text!.trim();
        
        // Cari posisi kurung kurawal pertama dan terakhir untuk mengambil hanya bagian JSON-nya saja
        // Ini mencegah error jika Gemini menambahkan kalimat ekstra setelah JSON atau format markdown ```json
        final int startIndex = rawText.indexOf('{');
        final int endIndex = rawText.lastIndexOf('}');
        
        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          final cleanJsonStr = rawText.substring(startIndex, endIndex + 1);
          final Map<String, dynamic> jsonResponse = jsonDecode(cleanJsonStr);
          if (jsonResponse['analytics_data'] != null) {
            jsonResponse['analytics_data']['mode'] = 'writing';
          }
          return jsonResponse;
        } else {
          // Fallback jika tidak ada kurung kurawal (meskipun tidak mungkin untuk JSON map)
          final Map<String, dynamic> jsonResponse = jsonDecode(rawText);
          if (jsonResponse['analytics_data'] != null) {
            jsonResponse['analytics_data']['mode'] = 'writing';
          }
          return jsonResponse;
        }
      }
    } catch (e) {
      print("❌ Error GeminiService: $e");
    }
    return null;
  }

  /// Mengevaluasi ejaan lisan anak (Speech-to-Text) dan mengembalikan JSON berisi feedback suara dan data analitik
  Future<Map<String, dynamic>?> evaluateSpelling({
    required String targetWord,
    required String spokenWord,
  }) async {
    if (_apiKey == 'API_KEY_GEMINI_ANDA_DISINI' || _apiKey.isEmpty) {
      print("⚠️ Peringatan: API Key Gemini belum diatur!");
      return null;
    }

    try {
      final prompt = '''
Kamu adalah guru TK yang sedang mengevaluasi ujian mengeja anak berusia 5-7 tahun melalui lisan.
Anak diminta mengeja secara lisan huruf atau kata: "$targetWord".
Namun, AI pengenal suara menangkap ejaan anak tersebut sebagai: "$spokenWord".

Tugasmu:
1. Buat "voice_feedback" berupa kalimat penyemangat singkat dalam Bahasa Indonesia. Jika ejaannya salah, beritahu cara mengeja yang benar (misal: "Hampir benar! Harusnya B-O-L-A. Yuk coba lagi!"). Gunakan bahasa yang sangat lembut, ceria, dan tidak menghakimi (Maksimal 2 kalimat).
2. Buat "analytics_data" untuk laporan orang tua (Big Data). Tentukan bagian ejaan yang kemungkinan salah atau terlewat (wrong_letters), jenis kesalahannya (error_type: "kesalahan_ejaan", "tidak_jelas", "salah_kata"), dan berikan estimasi accuracy_score (0-100).

Kembalikan WAJIB dalam format JSON yang valid persis seperti skema berikut ini:
{
  "voice_feedback": "Wah hampir benar! Tapi ejaan yang tepat adalah B-O-L-A yaa...",
  "analytics_data": {
    "target_word": "$targetWord",
    "written_word": "$spokenWord",
    "wrong_letters": ["huruf atau suku kata yang salah eja"],
    "error_type": "kesalahan_ejaan",
    "accuracy_score": 60
  }
}
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      if (response.text != null) {
        String rawText = response.text!.trim();
        
        final int startIndex = rawText.indexOf('{');
        final int endIndex = rawText.lastIndexOf('}');
        
        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          final cleanJsonStr = rawText.substring(startIndex, endIndex + 1);
          final Map<String, dynamic> jsonResponse = jsonDecode(cleanJsonStr);
          if (jsonResponse['analytics_data'] != null) {
            jsonResponse['analytics_data']['mode'] = 'spelling';
          }
          return jsonResponse;
        } else {
          final Map<String, dynamic> jsonResponse = jsonDecode(rawText);
          if (jsonResponse['analytics_data'] != null) {
            jsonResponse['analytics_data']['mode'] = 'spelling';
          }
          return jsonResponse;
        }
      }
    } catch (e) {
      print("❌ Error GeminiService (evaluateSpelling): $e");
    }
    return null;
  }
}
