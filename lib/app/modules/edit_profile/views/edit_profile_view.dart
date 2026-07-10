import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      appBar: AppBar(
        title: const Text(
          'Edit Profil 🎨',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        backgroundColor: EduTheme.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              
              // === PREVIEW AVATAR ===
              Obx(() => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                key: ValueKey(controller.selectedAvatar.value),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: EduTheme.primary, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: EduTheme.primary.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        controller.selectedAvatar.value,
                        style: const TextStyle(fontSize: 72),
                      ),
                    ),
                  );
                },
              )),
              
              const SizedBox(height: 30),
              
              // === INPUT NAMA ===
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama Panggilanmu:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: EduTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.nameController,
                maxLength: 15,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: EduTheme.textDark,
                ),
                decoration: InputDecoration(
                  hintText: "Siapa namamu?",
                  filled: true,
                  fillColor: Colors.white,
                  counterText: "",
                  prefixIcon: const Icon(Icons.person, color: EduTheme.primary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                    borderSide: const BorderSide(color: EduTheme.border, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                    borderSide: const BorderSide(color: EduTheme.primary, width: 3),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // === PILIH AVATAR ===
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih Karakter Favoritmu!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: EduTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.availableAvatars.length,
                itemBuilder: (context, index) {
                  final emoji = controller.availableAvatars[index];
                  return Obx(() {
                    final isSelected = controller.selectedAvatar.value == emoji;
                    return GestureDetector(
                      onTap: () => controller.selectAvatar(emoji),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected ? EduTheme.primaryLight : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? EduTheme.primary : EduTheme.border,
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: EduTheme.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: TextStyle(
                              fontSize: isSelected ? 36 : 30,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
              
              const SizedBox(height: 40),
              
              // === TOMBOL SIMPAN ===
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.saveProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EduTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                    ),
                    elevation: 4,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Simpan Profil ✨",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              )),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
