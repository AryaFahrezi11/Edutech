import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.bgPrimaryTint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: EduTheme.textDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: EduTheme.primaryLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: EduTheme.primary, width: 3),
                    boxShadow: EduTheme.buttonShadow(EduTheme.primary),
                  ),
                  child: const Center(
                    child: Icon(Icons.password_rounded, size: 54, color: EduTheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Buat Password Baru',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: EduTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: EduTheme.textMedium,
                  ),
                  children: [
                    const TextSpan(text: 'Masukkan kode rahasia yang dikirim ke\n'),
                    TextSpan(
                      text: controller.email,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: EduTheme.primary),
                    ),
                    const TextSpan(text: ' beserta password barumu.'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Form Card
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                    boxShadow: EduTheme.softShadow(),
                  ),
                  child: Column(
                    children: [
                      _buildInput(
                        title: 'Kode OTP (6 digit)',
                        hint: 'contoh: 123456',
                        icon: Icons.pin_outlined,
                        controller: controller.otpController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      _buildInput(
                        title: 'Password Baru',
                        hint: 'minimal 6 karakter',
                        icon: Icons.lock_outline,
                        controller: controller.newPasswordController,
                        obscure: true,
                      ),
                      const SizedBox(height: 16),

                      _buildInput(
                        title: 'Konfirmasi Password Baru',
                        hint: 'masukkan ulang password',
                        icon: Icons.check_circle_outline,
                        controller: controller.konfirmasiController,
                        obscure: true,
                      ),
                      const SizedBox(height: 24),
                      
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: controller.isLoading.value
                              ? const Center(child: CircularProgressIndicator(color: EduTheme.primary))
                              : GestureDetector(
                                  onTap: controller.submitResetPassword,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: EduTheme.primary,
                                      borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: EduTheme.primaryShadow,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "SIMPAN PASSWORD BARU",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String title,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: EduTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: EduTheme.textLight),
            prefixIcon: Icon(icon, color: EduTheme.primary),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(EduTheme.radiusMd),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(EduTheme.radiusMd),
              borderSide: const BorderSide(color: EduTheme.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(EduTheme.radiusMd),
              borderSide: const BorderSide(color: EduTheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
