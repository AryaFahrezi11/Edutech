import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/app_routes.dart';
import '../../../services/tts_service.dart';

class SplashController extends GetxController {
  late VideoPlayerController videoController;
  final isVideoInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      videoController = VideoPlayerController.asset('assets/video/splash.MOV');
      await videoController.initialize();
      
      isVideoInitialized.value = true;
      videoController.setLooping(false);
      
      // Beri jeda sedikit agar widget VideoPlayer di UI selesai di-render oleh Obx
      await Future.delayed(const Duration(milliseconds: 100));
      await videoController.play();
      
      // Mainkan suara sambutan awal
      Get.find<TtsService>().speak("Edutech, aplikasi belajar anak berbasis AI!");
      
      // Listen to the video position
      videoController.addListener(_checkVideoProgress);
    } catch (e) {
      print("Error initializing splash video: $e");
      // Jika video gagal diload, langsung pindah ke halaman berikutnya
      _navigateToNextScreen();
    }
  }

  void _checkVideoProgress() {
    if (videoController.value.isInitialized) {
      if (videoController.value.position >= videoController.value.duration) {
        // Video finished
        videoController.removeListener(_checkVideoProgress);
        _navigateToNextScreen();
      }
    }
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Hapus sesi lama agar setiap aplikasi di-close dari history (cold boot),
    // user harus melakukan login ulang.
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_avatar');

    // Selalu arahkan ke halaman Login
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
