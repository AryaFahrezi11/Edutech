import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

// Gunakan GetView<RegisterController>
class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller jika belum menggunakan Binding
    Get.put(RegisterController());

    return Scaffold(
      backgroundColor: const Color(0xffEEF2FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // ... (Bagian Header Icon Edutech dan Gambar biarkan sama persis seperti kodemu) ...
              // [Saya potong kodenya di sini agar tidak kepanjangan, pakai kode asli milikmu]

              const Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1565D8),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Yuk mulai belajar sambil bermain!',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    // --- SAMBUNGKAN CONTROLLER KE INPUT ---
                    _buildInput(
                      title: 'Nama Lengkap',
                      hint: 'Masukkan nama lengkap',
                      icon: Icons.person_outline,
                      inputController: controller.namaController, // Tambahkan ini
                    ),
                    const SizedBox(height: 16),

                    _buildInput(
                      title: 'Email',
                      hint: 'Masukkan alamat email',
                      icon: Icons.email_outlined,
                      inputController: controller.emailController, // Tambahkan ini
                    ),
                    const SizedBox(height: 16),

                    _buildInput(
                      title: 'Password',
                      hint: 'Masukkan password',
                      icon: Icons.lock_outline,
                      obscure: true,
                      inputController: controller.passwordController, // Tambahkan ini
                    ),
                    const SizedBox(height: 16),

                    _buildInput(
                      title: 'Konfirmasi Password',
                      hint: 'Ulangi password',
                      icon: Icons.check_circle_outline,
                      obscure: true,
                      inputController: controller.konfirmasiController, // Tambahkan ini
                    ),
                    const SizedBox(height: 24),

                    // --- TOMBOL DAFTAR ---
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: Obx(() => ElevatedButton(
                        // Jika isLoading true, matikan tombol. Jika false, panggil fungsi register
                        onPressed: controller.isLoading.value ? null : () {
                          controller.registerProcess();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2F80ED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 3,
                        ),
                        child: controller.isLoading.value 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Daftar Sekarang',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                      )),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun? ', style: TextStyle(color: Colors.black54)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text('Masuk', style: TextStyle(color: Color(0xff1565D8), fontWeight: FontWeight.bold)),
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

  // --- UPDATE WIDGET _buildInput ---
  Widget _buildInput({
    required String title,
    required String hint,
    required IconData icon,
    bool obscure = false,
    required TextEditingController inputController, // Wajibkan parameter ini
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: inputController, // Sambungkan ke TextField
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xff5AAE61)),
            filled: true,
            fillColor: const Color(0xffF4F6FA),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}