import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/bgm_service.dart';
import 'app/services/progress_service.dart';
import 'app/services/point_service.dart';
import 'app/services/tts_service.dart';
import 'app/services/sfx_service.dart';
import 'app/services/log_service.dart';
import 'app/services/gemini_service.dart';
import 'app/services/mongodb_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Konfigurasi agar AudioPlayers tidak mematikan suara satu sama lain
  await AudioPlayer.global.setAudioContext(AudioContextConfig(
    respectSilence: true,
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build());
  
  // Initialize services
  Get.put(SfxService());
  await Get.putAsync(() => ProgressService().init());
  await Get.putAsync(() => PointService().init());
  await Get.putAsync(() => TtsService().init());
  await Get.putAsync(() => LogService().init());
  await Get.putAsync(() => GeminiService().init());
  await Get.putAsync(() => MongoDbService().init());
  Get.put(BackgroundMusicService());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Edutech',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
      routingCallback: (routing) {
        if (routing != null) {
          final bgm = Get.find<BackgroundMusicService>();
          // Play music only on LOGIN and HOME
          if (routing.current == Routes.HOME || routing.current == Routes.LOGIN) {
            bgm.playBgm();
          } else {
            bgm.pauseBgm();
          }
        }
      },
      theme: ThemeData(
        primaryColor: const Color(0xFF1CB0F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1CB0F6),
          primary: const Color(0xFF1CB0F6),
          secondary: const Color(0xFF1CB0F6),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        fontFamily: 'Nunito',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1CB0F6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1CB0F6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}