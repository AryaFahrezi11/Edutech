import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class MultiplayerLobbyView extends StatefulWidget {
  const MultiplayerLobbyView({Key? key}) : super(key: key);

  @override
  State<MultiplayerLobbyView> createState() => _MultiplayerLobbyViewState();
}

class _MultiplayerLobbyViewState extends State<MultiplayerLobbyView> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Force Landscape for TV
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Revert to portrait/any
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  void _startBattle() {
    String p1 = player1Controller.text.trim();
    String p2 = player2Controller.text.trim();

    if (p1.isEmpty) p1 = "Tim Merah";
    if (p2.isEmpty) p2 = "Tim Biru";

    Get.toNamed(Routes.MULTIPLAYER_BATTLE, arguments: {
      'player1': p1,
      'player2': p2,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF), // Terang
      appBar: AppBar(
        title: const Text('Persiapan Duel', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1CB0F6),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Siapa yang Bertanding?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Player 1 Input
                      Expanded(
                        child: _buildPlayerInput(
                          title: "Pemain Kiri",
                          color: const Color(0xFFFF416C),
                          controller: player1Controller,
                          hint: "Tim Merah",
                          icon: Icons.person,
                        ),
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "VS",
                          style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: Color(0xFFFFD166), fontStyle: FontStyle.italic),
                        ),
                      ),
                      
                      // Player 2 Input
                      Expanded(
                        child: _buildPlayerInput(
                          title: "Pemain Kanan",
                          color: const Color(0xFF00C9FF),
                          controller: player2Controller,
                          hint: "Tim Biru",
                          icon: Icons.person_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  GestureDetector(
                    onTap: _startBattle,
                    child: Container(
                      width: 400,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFf7971e), Color(0xFFffd200)]),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFffd200).withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "MULAI BERTANDING! ⚔️",
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInput({
    required String title,
    required Color color,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
        border: Border.all(color: color.withOpacity(0.3), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            style: const TextStyle(color: Color(0xFF2C3E50), fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: color, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
