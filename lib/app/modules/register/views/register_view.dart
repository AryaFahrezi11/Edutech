import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());

    return Scaffold(
      backgroundColor: EduTheme.bgPrimaryTint,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Header
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: EduTheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: EduTheme.buttonShadow(EduTheme.primary),
                      ),
                      child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Edutech',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: EduTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Mascot
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: const Text("🎒", style: TextStyle(fontSize: 64)),
              ),

              const SizedBox(height: 12),

              const Text(
                'Mulai Petualangan! 🚀',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: EduTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Yuk daftar dan mulai belajar sambil bermain!',
                style: TextStyle(fontSize: 14, color: EduTheme.textMedium),
              ),
              const SizedBox(height: 24),

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
                      title: 'Nama Lengkap',
                      hint: 'Masukkan nama lengkap',
                      icon: Icons.person_outline,
                      inputController: controller.namaController,
                    ),
                    const SizedBox(height: 16),

                    _buildInput(
                      title: 'Email',
                      hint: 'Masukkan alamat email',
                      icon: Icons.email_outlined,
                      inputController: controller.emailController,
                    ),
                    const SizedBox(height: 16),

                    _buildInput(
                      title: 'Password',
                      hint: 'Masukkan password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      inputController: controller.passwordController,
                    ),
                    const SizedBox(height: 16),

                    _buildInput(
                      title: 'Konfirmasi Password',
                      hint: 'Ulangi password',
                      icon: Icons.check_circle_outline,
                      isKonfirmasi: true,
                      inputController: controller.konfirmasiController,
                    ),
                    const SizedBox(height: 24),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Obx(() => controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator(color: EduTheme.primary))
                          : GestureDetector(
                              onTap: controller.registerProcess,
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
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("✨", style: TextStyle(fontSize: 20)),
                                    SizedBox(width: 8),
                                    Text(
                                      'DAFTAR SEKARANG',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun? ', style: TextStyle(color: EduTheme.textMedium)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(color: EduTheme.primary, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
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
    bool isPassword = false,
    bool isKonfirmasi = false,
    required TextEditingController inputController,
  }) {
    Widget buildTextField(bool obscure) {
      return TextField(
        controller: inputController,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: EduTheme.textLight),
          prefixIcon: Icon(icon, color: EduTheme.primary),
          suffixIcon: (isPassword || isKonfirmasi)
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: EduTheme.primary,
                  ),
                  onPressed: isPassword 
                      ? controller.togglePasswordVisibility 
                      : controller.toggleKonfirmasiVisibility,
                )
              : null,
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
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: EduTheme.textDark)),
        const SizedBox(height: 8),
        if (isPassword)
          Obx(() => buildTextField(controller.isPasswordHidden.value))
        else if (isKonfirmasi)
          Obx(() => buildTextField(controller.isKonfirmasiHidden.value))
        else
          buildTextField(false),
      ],
    );
  }
}