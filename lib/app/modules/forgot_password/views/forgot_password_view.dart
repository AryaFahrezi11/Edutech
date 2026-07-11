import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
              const SizedBox(height: 20),
              
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: EduTheme.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "🔑",
                        style: TextStyle(fontSize: 64),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Lupa Password?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: EduTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masukkan email akunmu,\nkami akan mengirimkan kode rahasia untuk meresetnya.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: EduTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              _buildInput(
                title: 'Alamat Email',
                hint: 'contoh: petualang@email.com',
                icon: Icons.email_outlined,
                controller: controller.emailController,
              ),
              
              const SizedBox(height: 40),
              
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator(color: EduTheme.primary))
                      : GestureDetector(
                          onTap: controller.sendResetOtp,
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
                                "KIRIM KODE OTP",
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
