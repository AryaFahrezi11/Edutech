import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
                    child: Icon(Icons.lock_reset_rounded, size: 54, color: EduTheme.primary),
                  ),
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
              const SizedBox(height: 32),
              
              // Form Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                  boxShadow: EduTheme.softShadow(),
                ),
                child: Column(
                  children: [
                    _buildInput(
                      title: 'Alamat Email',
                      hint: 'contoh: petualang@email.com',
                      icon: Icons.email_outlined,
                      controller: controller.emailController,
                    ),
                    const SizedBox(height: 24),
                    
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
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: EduTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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
