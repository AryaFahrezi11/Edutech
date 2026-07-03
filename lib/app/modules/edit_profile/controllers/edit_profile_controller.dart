import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/config/api_endpoints.dart';
import '../../home/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  
  var isLoading = false.obs;
  var selectedAvatar = "🧒".obs;

  final List<String> availableAvatars = [
    "🧒", "👧", "🦊", "🐻", 
    "🐶", "🐼", "🦁", "🐰", 
    "🐯", "🐵", "🦄", "🐧"
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('user_name') ?? "";
    selectedAvatar.value = prefs.getString('user_avatar') ?? "🧒";
  }

  void selectAvatar(String emoji) {
    selectedAvatar.value = emoji;
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Oops!", "Nama tidak boleh kosong ya!", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('user_email') ?? "";

      final url = Uri.parse(ApiEndpoints.updateProfile);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "69420"
        },
        body: jsonEncode({
          "email": email,
          "nama_lengkap": nameController.text.trim(),
          "profile_pict": selectedAvatar.value
        }),
      );

      if (response.statusCode == 200) {
        // Save to SharedPreferences
        await prefs.setString('user_name', nameController.text.trim());
        await prefs.setString('user_avatar', selectedAvatar.value);

        // Update active controllers
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().userName.value = nameController.text.trim();
          Get.find<HomeController>().userAvatar.value = selectedAvatar.value;
        }
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().userName.value = nameController.text.trim();
          Get.find<ProfileController>().userAvatar.value = selectedAvatar.value;
        }

        Get.back();
        Get.snackbar("Berhasil! 🎉", "Profil kamu sudah diperbarui!", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Gagal 😔", "Ada masalah saat menyimpan profil. Coba lagi ya!", backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Gagal terhubung ke server.", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
