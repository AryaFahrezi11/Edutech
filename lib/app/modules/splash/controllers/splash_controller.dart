import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void onInit() {
    super.onInit();
    _playGreetingAndNavigate();
  }

  Future<void> _playGreetingAndNavigate() async {
    // Tunggu sebentar agar UI render dulu
    await Future.delayed(const Duration(milliseconds: 500));

    // Setup TTS
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.4); // Suara agak lambat untuk anak
    await flutterTts.setPitch(1.2); // Suara agak melengking/lucu

    // Ucapkan kalimat
    await flutterTts.speak("Edutech, aplikasi belajar anak berbasis A.I.");

    // Tunggu beberapa detik untuk memastikan suara selesai, 
    // lalu pindah ke halaman login.
    // Jika ada sistem auto-login, bisa dicek di sini.
    await Future.delayed(const Duration(seconds: 4));
    
    Get.offAllNamed(Routes.LOGIN);
  }
}
