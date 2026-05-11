import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau Icon Edutech
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.school, size: 50, color: Color(0xFF1E52D0)),
              ),
              const SizedBox(height: 20),
              const Text(
                "Edutech",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E52D0)),
              ),
              const Text("Belajar Menulis & Mengeja Jadi Mudah", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 50),

              // Input Email
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),

              // Input Password
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Masuk Utama
              Obx(() => SizedBox(
                width: double.infinity,
                height: 55,
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: controller.loginProcess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E52D0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("Masuk", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
              )),

              const SizedBox(height: 25),
              const Text("atau", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),

              // Tombol Login Google
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: controller.loginWithGoogle,
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2008px-Google_%22G%22_Logo.svg.png',
                    height: 24,
                  ),
                  label: const Text(
                    "Masuk dengan Google",
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}