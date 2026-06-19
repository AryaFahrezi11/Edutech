import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54, // Gelap transparan sebagai background popup
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            decoration: BoxDecoration(
              color: EduTheme.bgPrimaryTint,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tombol Close
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: EduTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, color: EduTheme.primary, size: 20),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),

                // Icon / Mascot Animasi
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
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
                      child: Icon(
                        Icons.mark_email_read_rounded,
                        size: 50,
                        color: EduTheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Teks Instruksi
                const Text(
                  'Cek Emailmu! 📧',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: EduTheme.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Obx(() => Text(
                  'Kami telah mengirim 6 angka\nKode Rahasia ke:\n${controller.email.value}',
                  style: const TextStyle(fontSize: 14, color: EduTheme.textMedium),
                  textAlign: TextAlign.center,
                )),

                const SizedBox(height: 28),

                // Kotak Input OTP Custom
                _buildOtpBoxes(),

                const SizedBox(height: 28),

                // Tombol Verifikasi
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator(color: EduTheme.primary))
                        : _buildGreenButton(
                            label: 'VERIFIKASI',
                            emoji: '✨',
                            onTap: controller.verifyOtpProcess,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget 1 kotak 1 angka
  Widget _buildOtpBoxes() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Kotak-kotak visualnya
        Obx(() {
          String text = controller.otpText.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              bool isFilled = index < text.length;
              bool isActive = index == text.length; // Kotak yang sedang fokus
              
              return Container(
                width: 42,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isFilled ? EduTheme.primaryLight : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? EduTheme.primary : (isFilled ? EduTheme.primary : EduTheme.border),
                    width: isActive ? 2.5 : 2,
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(color: EduTheme.primary.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)
                  ] : null,
                ),
                child: Text(
                  isFilled ? text[index] : "",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: EduTheme.primary,
                  ),
                ),
              );
            }),
          );
        }),

        // Textfield tersembunyi yang menangkap inputan keyboard
        Positioned.fill(
          child: TextField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            showCursor: false, // Sembunyikan kursor
            autofocus: true,
            style: const TextStyle(color: Colors.transparent, fontSize: 1), // Teks tak terlihat
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Hanya angka
            decoration: const InputDecoration(
              counterText: "", // Hilangkan counter di bawah
              border: InputBorder.none, // Hilangkan garis
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent, // Transparan
              filled: true,
            ),
            onChanged: (val) {
              // Update state agar kotak visualnya bereaksi
              controller.otpText.value = val;
              
              // Opsional: Langsung submit jika sudah 6 angka
              if (val.length == 6) {
                 // Hilangkan fokus keyboard jika sudah 6 karakter
                 FocusManager.instance.primaryFocus?.unfocus();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGreenButton({
    required String label,
    required String emoji,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: EduTheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
              color: EduTheme.primaryShadow,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
