import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/api_endpoints.dart';
import '../../../services/tts_service.dart';

class LeaderboardController extends GetxController {
  var isLoading = true.obs;
  var leaderboardData = <Map<String, dynamic>>[].obs;
  var currentUserEmail = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserEmail();
    fetchLeaderboard();
  }

  Future<void> _loadCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserEmail.value = prefs.getString('user_email') ?? "";
  }

  Future<void> fetchLeaderboard() async {
    try {
      isLoading(true);
      final url = Uri.parse(ApiEndpoints.leaderboard);
      final response = await http.get(
        url,
        headers: {"ngrok-skip-browser-warning": "69420"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Konversi dari List<dynamic> ke List<Map<String, dynamic>>
          var list = List<Map<String, dynamic>>.from(data['leaderboard']);

          // Set property 'active' untuk user saat ini
          for (var item in list) {
            if (item['email'] == currentUserEmail.value &&
                currentUserEmail.value.isNotEmpty) {
              item['active'] = true;
            }
          }

          leaderboardData.value = list;
        }
      } else {
        print("Gagal mengambil leaderboard, status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetchLeaderboard: $e");
    } finally {
      isLoading(false);
    }
  }

  void playUserRank(String rank, String name, String score) {
    String rankText = rank == "1"
        ? "Juara 1"
        : rank == "2"
        ? "Juara 2"
        : rank == "3"
        ? "Juara 3"
        : "Peringkat $rank";
    String speech = "$rankText, adalah $name, dengan total skor $score koin!";
    Get.find<TtsService>().speak(speech);
  }
}
