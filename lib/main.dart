import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/bgm_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Service Background Music secara global
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