import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/log_service.dart';
import '../../../services/point_service.dart';
import '../../../services/progress_service.dart';

class ProfileController extends GetxController {
  
  var userName = "Memuat...".obs;
  var userEmail = "Memuat...".obs;
  var userAvatar = "🧒".obs;
  
  final pointService = Get.find<PointService>();
  final progressService = Get.find<ProgressService>();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    // Load data log saat profil dibuka
    Get.find<LogService>().fetchLogs();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? "Petualang Hebat";
    userEmail.value = prefs.getString('user_email') ?? "petualang@edutech.com";
    userAvatar.value = prefs.getString('user_avatar') ?? "🧒";
  }

  // Getters untuk UI
  int get totalPoints => pointService.totalPoints.value;
  int get streakDays => pointService.streakDays.value;
  
  // Karena _completedItems bersifat private di PointService,
  // kita ambil jumlah dari gabungan progress yang ada.
  // Tapi progressService memiliki getUnlockedLetters, dll yang bisa dihitung.
  int get totalMissions => progressService.unlockedWritingLetter.value 
                         + progressService.unlockedWritingWord.value
                         + progressService.unlockedSpellingLetter.value
                         + progressService.unlockedSpellingWord.value;
}