import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/tts_service.dart';
import '../services/gemini_service.dart';

class OwlChatDialog extends StatefulWidget {
  const OwlChatDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const OwlChatDialog(),
    );
  }

  @override
  State<OwlChatDialog> createState() => _OwlChatDialogState();
}

class _OwlChatDialogState extends State<OwlChatDialog> {
  VideoPlayerController? _speakingController;
  VideoPlayerController? _idleController;
  VideoPlayerController? _thinkingController;
  bool _isInitialized = false;

  bool _isSpeaking = false;
  bool _isThinking = false;
  bool _isListening = false;

  final stt.SpeechToText _speech = stt.SpeechToText();
  String _spokenText = '';
  
  @override
  void initState() {
    super.initState();
    _initVideo();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (_isListening) {
            _stopListeningAndSend();
          }
        }
      },
      onError: (error) {
        if (_isListening) {
          _stopListeningAndSend();
        }
      },
    );
  }

  Future<void> _initVideo() async {
    try {
      _speakingController = VideoPlayerController.asset('assets/video/owel.mp4');
      _idleController = VideoPlayerController.asset('assets/video/idle.mp4');
      _thinkingController = VideoPlayerController.asset('assets/video/thinking.mp4');

      await Future.wait([
        _speakingController!.initialize(),
        _idleController!.initialize(),
        _thinkingController!.initialize(),
      ]);

      void addLoopListener(VideoPlayerController ctrl) {
        ctrl.addListener(() {
          if (mounted) setState(() {});
          if (ctrl.value.isPlaying && ctrl.value.duration > Duration.zero) {
            final isNearEnd = ctrl.value.position >= (ctrl.value.duration - const Duration(milliseconds: 150));
            if (isNearEnd) {
              ctrl.seekTo(Duration.zero);
            }
          }
        });
      }

      addLoopListener(_speakingController!);
      addLoopListener(_idleController!);
      addLoopListener(_thinkingController!);

      await _speakingController!.setVolume(0.0);
      await _speakingController!.setLooping(true);
      await _idleController!.setVolume(0.0);
      await _idleController!.setLooping(true);
      await _thinkingController!.setVolume(0.0);
      await _thinkingController!.setLooping(true);

      setState(() {
        _isInitialized = true;
      });

      await _idleController!.play();
      
      // Ambil nama dari HomeController
      String userName = "Teman";
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('user_name');
      userName = (savedName != null && savedName.isNotEmpty) ? savedName : "Teman";

      // Auto greet
      await _speakOwl("Halo $userName! Aku Owl. Aku siap menemani belajar bareng $userName. Ada yang ingin kamu tanyakan?");
    } catch (e) {
      print("❌ Error load local video: $e");
    }
  }

  Future<void> _speakOwl(String text) async {
    if (!mounted) return;
    setState(() {
      _isThinking = false;
      _isSpeaking = true;
    });
    _idleController?.pause();
    _thinkingController?.pause();
    _speakingController?.seekTo(Duration.zero);
    _speakingController?.play();

    await Get.find<TtsService>().speakAndWait(text);

    if (mounted) {
      setState(() {
        _isSpeaking = false;
      });
      _speakingController?.pause();
      _idleController?.play();
    }
  }

  Future<void> _startListening() async {
    Get.find<TtsService>().stop();
    _speakingController?.pause();
    _thinkingController?.pause();
    _idleController?.play();

    if (_speech.isAvailable || await _speech.initialize()) {
      setState(() {
        _isListening = true;
        _spokenText = '';
        _isSpeaking = false;
        _isThinking = false;
      });
      
      await _speech.listen(
        localeId: 'id_ID',
        partialResults: true,
        cancelOnError: false,
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        onResult: (result) {
          if (mounted) {
            setState(() {
              _spokenText = result.recognizedWords;
            });
            if (result.finalResult && _spokenText.isNotEmpty) {
              _stopListeningAndSend();
            }
          }
        },
      );
    }
  }

  Future<void> _stopListeningAndSend() async {
    if (!_isListening) return;
    setState(() {
      _isListening = false;
    });
    
    try {
      _speech.stop();
    } catch (_) {}

    final text = _spokenText.trim();
    if (text.isEmpty) {
      _speakOwl("Aku tidak mendengar suara kamu.");
      return;
    }

    setState(() {
      _isThinking = true;
    });
    _idleController?.pause();
    _thinkingController?.seekTo(Duration.zero);
    _thinkingController?.play();

    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    final userName = (savedName != null && savedName.isNotEmpty) ? savedName : "Teman";

    final response = await Get.find<GeminiService>().chatWithOwel(text, userName);
    
    if (!mounted) return;

    if (response != null && response.isNotEmpty) {
      await _speakOwl(response);
    } else {
      await _speakOwl("Maaf ya, Owl sedang bingung nih.");
    }
  }

  @override
  void dispose() {
    Get.find<TtsService>().stop();
    _speakingController?.dispose();
    _idleController?.dispose();
    _thinkingController?.dispose();
    try {
      _speech.stop();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.blue.shade200, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: Colors.blue.shade100)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.mic_rounded, color: Colors.blue.shade700, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        "Belajar Bareng Owl",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.grey.shade600, size: 28),
                    onPressed: () {
                      Get.back();
                    },
                  )
                ],
              ),
            ),
            
            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Owl Video
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 320,
                      width: double.infinity,
                      color: Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          if (!_isThinking && !_isSpeaking && !_isListening) {
                            Get.find<TtsService>().stop();
                            _speakOwl("Halloww, aku Owl!");
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_isInitialized)
                              SizedBox.expand(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: 1600, 
                                    height: 900,
                                    child: VideoPlayer(
                                      _isThinking 
                                          ? _thinkingController! 
                                          : (_isSpeaking ? _speakingController! : _idleController!),
                                    ),
                                  ),
                                ),
                              )
                            else
                              const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Spoken Text Indicator
                  if (_spokenText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '"$_spokenText"',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade900,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    const SizedBox(height: 10),

                  // Mic Button
                  GestureDetector(
                    onTap: _isThinking ? null : (_isListening ? _stopListeningAndSend : _startListening),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isThinking
                            ? Colors.grey.shade400
                            : (_isListening ? Colors.redAccent : Colors.blue.shade600),
                        boxShadow: [
                          if (_isListening)
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                        ],
                      ),
                      child: _isThinking
                          ? const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Icon(
                              _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isThinking 
                        ? "Owl sedang berpikir..." 
                        : (_isListening 
                            ? "Sedang mendengarkan... (Ketuk untuk berhenti)" 
                            : (_isSpeaking ? "Owl sedang menjawab..." : "Ketuk mic untuk bicara!")),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
