import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Edutech',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.LOGIN, // Halaman pertama yang dibuka
      getPages: AppPages.pages,   // Daftar semua halaman
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito', // Cocok untuk font anak-anak
      ),
    );
  }
}