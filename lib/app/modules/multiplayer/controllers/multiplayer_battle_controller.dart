import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/sfx_service.dart';
import '../../../services/bgm_service.dart';
import '../../../services/tts_service.dart';

class PKChallenge {
  final String word;
  final String emoji;
  PKChallenge({required this.word, required this.emoji});
}

class PlayerState {
  RxInt score = 0.obs;
  RxInt currentChallengeIndex = 0.obs;
  // Filled letters by the user. If a slot is empty, it's an empty string.
  RxList<String> filledLetters = <String>[].obs;
  // Scrambled choices available below. Empty string if it has been picked.
  RxList<String> scrambledLetters = <String>[].obs;
  
  // For shake animation on wrong answer
  RxBool isShaking = false.obs;
}

class MultiplayerBattleController extends GetxController {
  final SfxService _sfx = Get.find<SfxService>();
  final BackgroundMusicService _bgm = Get.find<BackgroundMusicService>();

  late String player1Name;
  late String player2Name;

  final player1 = PlayerState();
  final player2 = PlayerState();

  // PK Bar ratio
  var pkRatio = 0.5.obs;
  
  var timeLeft = 60.obs;
  var isGameRunning = false.obs;
  var isGameOver = false.obs;
  Timer? _timer;

  final List<PKChallenge> allChallenges = [
    PKChallenge(word: "B U K U", emoji: "📚"),
    PKChallenge(word: "A P E L", emoji: "🍎"),
    PKChallenge(word: "B O L A", emoji: "⚽"),
    PKChallenge(word: "T O P I", emoji: "🧢"),
    PKChallenge(word: "M E J A", emoji: "🪑"),
    PKChallenge(word: "S U S U", emoji: "🥛"),
    PKChallenge(word: "R O T I", emoji: "🍞"),
    PKChallenge(word: "I K A N", emoji: "🐟"),
    PKChallenge(word: "S A P I", emoji: "🐄"),
    PKChallenge(word: "K U D A", emoji: "🐎"),
    PKChallenge(word: "B A J U", emoji: "👕"),
    PKChallenge(word: "M A T A", emoji: "👁️"),
  ];

  late List<PKChallenge> p1Challenges;
  late List<PKChallenge> p2Challenges;

  @override
  void onInit() {
    super.onInit();
    player1Name = Get.arguments?['player1'] ?? "Tim Merah";
    player2Name = Get.arguments?['player2'] ?? "Tim Biru";

    final shuffled = List<PKChallenge>.from(allChallenges)..shuffle();
    p1Challenges = List.from(shuffled);
    p2Challenges = List.from(shuffled);

    _setupChallenge(player1, p1Challenges);
    _setupChallenge(player2, p2Challenges);

    // Play battle BGM
    _bgm.playBattleBgm();

    // Sapaan awal pertempuran
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.find<TtsService>().speak("Pertandingan dimulai! Siapa yang paling cepat menyusun kata?");
    });

    startGame();
  }

  void startGame() {
    isGameRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        endGame();
      }
    });
  }

  void endGame() {
    _timer?.cancel();
    isGameRunning.value = false;
    isGameOver.value = true;
    _sfx.playSuccess();
    _bgm.stopBgm(); // Stop battle music
    _showWinnerDialog();
  }

  void _setupChallenge(PlayerState player, List<PKChallenge> challenges) {
    if (player.currentChallengeIndex.value >= challenges.length) {
      player.currentChallengeIndex.value = 0;
    }
    
    String word = challenges[player.currentChallengeIndex.value].word.replaceAll(" ", "");
    
    // Initialize filled letters as empty strings
    player.filledLetters.value = List.filled(word.length, "");
    
    List<String> letters = word.split('');
    letters.shuffle();
    player.scrambledLetters.value = letters;
  }

  // When tapping a letter from the scrambled options
  void onScrambledLetterTap(PlayerState player, List<PKChallenge> challenges, int index) {
    if (!isGameRunning.value) return;
    String letter = player.scrambledLetters[index];
    if (letter.isEmpty) return; // Already picked

    // Find first empty slot in filledLetters
    int emptyIndex = player.filledLetters.indexOf("");
    if (emptyIndex != -1) {
      _sfx.playCoin(); // small click sound
      player.filledLetters[emptyIndex] = letter;
      player.scrambledLetters[index] = ""; // Mark as picked
      
      // Check if word is now fully assembled
      if (!player.filledLetters.contains("")) {
        _validateWord(player, challenges);
      }
    }
  }

  // When tapping a letter in the filled boxes (to undo)
  void onFilledLetterTap(PlayerState player, int index) {
    if (!isGameRunning.value) return;
    String letter = player.filledLetters[index];
    if (letter.isEmpty) return;

    // Find an empty spot in scrambledLetters to put it back
    int emptyIndex = player.scrambledLetters.indexOf("");
    if (emptyIndex != -1) {
      _sfx.playCoin();
      player.scrambledLetters[emptyIndex] = letter;
      player.filledLetters[index] = "";
    }
  }

  void _validateWord(PlayerState player, List<PKChallenge> challenges) {
    String currentWord = challenges[player.currentChallengeIndex.value].word.replaceAll(" ", "");
    String assembledWord = player.filledLetters.join("");

    if (assembledWord == currentWord) {
      // Correct!
      _sfx.playSuccess();
      player.score.value += 10;
      _updatePKRatio();
      
      Future.delayed(const Duration(milliseconds: 500), () {
        player.currentChallengeIndex.value++;
        _setupChallenge(player, challenges);
      });
    } else {
      // Wrong!
      _sfx.playWrong();
      _shakeError(player);
      
      // Reset the boxes after a short delay
      Future.delayed(const Duration(milliseconds: 800), () {
        // Return all letters back to scrambled
        for (int i = 0; i < player.filledLetters.length; i++) {
          if (player.filledLetters[i].isNotEmpty) {
            int emptyIndex = player.scrambledLetters.indexOf("");
            if (emptyIndex != -1) {
              player.scrambledLetters[emptyIndex] = player.filledLetters[i];
              player.filledLetters[i] = "";
            }
          }
        }
      });
    }
  }

  void _shakeError(PlayerState player) {
    player.isShaking.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      player.isShaking.value = false;
    });
  }

  void _updatePKRatio() {
    int s1 = player1.score.value;
    int s2 = player2.score.value;
    
    if (s1 == 0 && s2 == 0) {
      pkRatio.value = 0.5;
      return;
    }
    
    double ratio = (s1 + 20) / (s1 + s2 + 40);
    pkRatio.value = ratio;
  }

  void _showWinnerDialog() {
    String winnerName = "Seimbang!";
    Color winnerColor = Colors.grey;
    if (player1.score.value > player2.score.value) {
      winnerName = "$player1Name Menang!";
      winnerColor = const Color(0xFFFF416C);
    } else if (player2.score.value > player1.score.value) {
      winnerName = "$player2Name Menang!";
      winnerColor = const Color(0xFF00C9FF);
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: winnerColor, width: 4),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("WAKTU HABIS!", style: TextStyle(fontSize: 20, color: Color(0xFF2C3E50), fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("🏆", style: TextStyle(fontSize: 60, shadows: [Shadow(color: winnerColor.withValues(alpha: 0.5), blurRadius: 20)])),
                const SizedBox(height: 10),
                Text(winnerName, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: winnerColor), textAlign: TextAlign.center),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text("Skor Kiri", style: TextStyle(color: Colors.black54)),
                        Text("${player1.score.value}", style: const TextStyle(fontSize: 24, color: Color(0xFFFF416C), fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Skor Kanan", style: TextStyle(color: Colors.black54)),
                        Text("${player2.score.value}", style: const TextStyle(fontSize: 24, color: Color(0xFF00C9FF), fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: winnerColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.back(); // back to lobby
                  },
                  child: const Text("TUTUP ARENA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    _bgm.playBgm(); // Restore normal bgm
    super.onClose();
  }
}
