import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: EduTheme.textDark),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 10),
              
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: EduTheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "🔒",
                        style: TextStyle(fontSize: 64),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Buat Password Baru',
                      style: TextStyle(
                        fontSize: 26,
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
                          const TextSpan(text: 'Masukkan kode rahasia yang dikirim ke '),
                          TextSpan(
                            text: controller.email,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: EduTheme.primary),
                          ),
                          const TextSpan(text: ' beserta password barumu.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              _buildInput(
                title: 'Kode OTP (6 digit)',
                hint: 'contoh: 123456',
                icon: Icons.pin_outlined,
                controller: controller.otpController,
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 20),

              _buildInput(
                title: 'Password Baru',
                hint: 'minimal 6 karakter',
                icon: Icons.lock_outline,
                controller: controller.newPasswordController,
                obscure: true,
              ),

              const SizedBox(height: 20),

              _buildInput(
                title: 'Konfirmasi Password Baru',
                hint: 'masukkan ulang password',
                icon: Icons.lock_reset_outlined,
                controller: controller.konfirmasiController,
                obscure: true,
              ),
              
              const SizedBox(height: 40),
              
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
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: EduTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: EduTheme.border, width: 2),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: EduTheme.textDark,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: EduTheme.textMedium,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(icon, color: EduTheme.textMedium),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
