import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../../config/api_endpoints.dart';
import '../services/tts_service.dart';

class BuGuruAvatarDialog extends StatefulWidget {
  final String? videoUrl;
  final String? talkId;
  final String? voiceFeedback;
  final Future<String?>? voiceFeedbackFuture;
  final String? avatarImageUrl;
  final String? userAnswer;
  final String? correctAnswer;
  final List<Offset?>? userPoints;
  final VoidCallback? onClose;

  const BuGuruAvatarDialog({
    super.key,
    this.videoUrl,
    this.talkId,
    this.voiceFeedback,
    this.voiceFeedbackFuture,
    this.avatarImageUrl,
    this.userAnswer,
    this.correctAnswer,
    this.userPoints,
    this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    String? videoUrl,
    String? talkId,
    String? voiceFeedback,
    Future<String?>? voiceFeedbackFuture,
    String? avatarImageUrl,
    String? userAnswer,
    String? correctAnswer,
    List<Offset?>? userPoints,
    VoidCallback? onClose,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BuGuruAvatarDialog(
        videoUrl: videoUrl,
        talkId: talkId,
        voiceFeedback: voiceFeedback,
        voiceFeedbackFuture: voiceFeedbackFuture,
        avatarImageUrl: avatarImageUrl,
        userAnswer: userAnswer,
        correctAnswer: correctAnswer,
        userPoints: userPoints,
        onClose: onClose,
      ),
    );
  }

  @override
  State<BuGuruAvatarDialog> createState() => _BuGuruAvatarDialogState();
}

class _BuGuruAvatarDialogState extends State<BuGuruAvatarDialog> {
  VideoPlayerController? _speakingController;
  VideoPlayerController? _idleController;
  VideoPlayerController? _thinkingController;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _canClose = false;
  bool _isSpeaking = false;
  bool _isEvaluating = false;
  String? _resolvedFeedback;

  @override
  void initState() {
    super.initState();
    if (widget.voiceFeedbackFuture != null) {
      _isEvaluating = true;
      _canClose = false;
    } else if (widget.voiceFeedback == null || widget.voiceFeedback!.isEmpty) {
      _canClose = true;
    }
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      print("🎬 Memuat video lokal: assets/video/owel.mp4, idle.mp4, dan thinking.mp4");
      _speakingController = VideoPlayerController.asset(
        'assets/video/owel.mp4',
      );
      _idleController = VideoPlayerController.asset('assets/video/idle.mp4');
      _thinkingController = VideoPlayerController.asset('assets/video/thinking.mp4');

      await Future.wait([
        _speakingController!.initialize(),
        _idleController!.initialize(),
        _thinkingController!.initialize(),
      ]).timeout(const Duration(seconds: 15));

      void addLoopListener(VideoPlayerController ctrl) {
        ctrl.addListener(() {
          if (mounted) setState(() {});
          if (ctrl.value.isPlaying && ctrl.value.duration > Duration.zero) {
            final isNearEnd =
                ctrl.value.position >=
                (ctrl.value.duration - const Duration(milliseconds: 150));
            if (isNearEnd) {
              ctrl.seekTo(Duration.zero);
            }
          }
        });
      }

      addLoopListener(_speakingController!);
      addLoopListener(_idleController!);
      addLoopListener(_thinkingController!);

      setState(() {
        _isInitialized = true;
      });

      await _speakingController!.setVolume(0.0);
      await _speakingController!.setLooping(true);
      await _idleController!.setVolume(0.0);
      await _idleController!.setLooping(true);
      await _thinkingController!.setVolume(0.0);
      await _thinkingController!.setLooping(true);

      try {
        if (widget.voiceFeedbackFuture != null) {
          await _thinkingController!.play();
        } else {
          await _idleController!.play();
        }
      } catch (playError) {
        print("⚠️ Direct play error: $playError");
      }

      if (widget.voiceFeedbackFuture != null) {
        try {
          final feedback = await widget.voiceFeedbackFuture!;
          _resolvedFeedback = feedback;
          
          if (feedback != null && feedback.isNotEmpty) {
            if (mounted) {
              setState(() {
                _isEvaluating = false;
                _isSpeaking = true;
                _canClose = false;
              });
              _thinkingController?.pause();
              _idleController?.pause();
              _speakingController?.play();
            }
            
            await Get.find<TtsService>().speakAndWait(feedback);
            
            if (mounted) {
              setState(() {
                _canClose = true;
                _isSpeaking = false;
              });
              _speakingController?.pause();
              _idleController?.play();
            }
          } else {
            if (mounted) {
              setState(() {
                _isEvaluating = false;
                _canClose = true;
                _isSpeaking = false;
              });
              _thinkingController?.pause();
              _idleController?.play();
            }
          }
        } catch (e) {
          print("❌ Error awaiting feedback: $e");
          if (mounted) {
            setState(() {
              _isEvaluating = false;
              _canClose = true;
            });
            _thinkingController?.pause();
            _idleController?.play();
          }
        }
      } else if (widget.voiceFeedback != null && widget.voiceFeedback!.isNotEmpty) {
        _resolvedFeedback = widget.voiceFeedback;
        if (mounted) {
          setState(() {
            _isSpeaking = true;
            _canClose = false;
          });
          _idleController?.pause();
          _speakingController?.play();
        }
        await Get.find<TtsService>().speakAndWait(widget.voiceFeedback!);
        if (mounted) {
          setState(() {
            _canClose = true;
            _isSpeaking = false;
          });
          _speakingController?.pause();
          _idleController?.play();
        }
      } else {
        if (mounted) {
          setState(() {
            _isSpeaking = false;
          });
          _speakingController?.pause();
          _idleController?.play();
        }
      }
    } catch (e) {
      print("❌ Error load local video: $e");
      _fallbackToTts();
    }
  }

  void _fallbackToTts() async {
    if (mounted) {
      setState(() {
        _hasError = true;
      });
      
      String? feedback = widget.voiceFeedback;
      if (widget.voiceFeedbackFuture != null) {
        try {
          feedback = await widget.voiceFeedbackFuture;
          _resolvedFeedback = feedback;
        } catch (e) {
          print("❌ Error fallback TTS: $e");
        }
      }

      if (mounted) {
        setState(() {
          _isEvaluating = false;
        });
      }

      if (feedback != null && feedback.isNotEmpty) {
        await Get.find<TtsService>().speakAndWait(feedback);
        if (mounted) {
          setState(() {
            _canClose = true;
          });
          _speakingController?.pause();
        }
      } else {
        if (mounted) {
          setState(() {
            _canClose = true;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _speakingController?.dispose();
    _idleController?.dispose();
    _thinkingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tts = Get.find<TtsService>();

    return WillPopScope(
      onWillPop: () async => _canClose,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Dialog
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          "Evaluasi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: _canClose ? Colors.grey : Colors.grey.shade300,
                      ),
                      onPressed: (!_canClose || _isEvaluating)
                          ? null
                          : () {
                              _speakingController?.pause();
                              _idleController?.pause();
                              _thinkingController?.pause();
                              tts.stop();
                              Get.back();
                              if (widget.onClose != null) widget.onClose!();
                            },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Papan Tulis
                    Expanded(
                      flex: 3,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 274),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF2B3A29,
                          ), // Warna hijau papan tulis
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF8B4513), // Warna kayu
                            width: 8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _isEvaluating
                            ? [ const SizedBox.shrink() ]
                            : [
                                const Text(
                                  "Kesalahan:",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                if (widget.userPoints != null &&
                                    widget.userPoints!.isNotEmpty)
                                  Container(
                                    height: 100,
                                    width: 140,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: SizedBox(
                                          width: 300,
                                          height: 300,
                                          child: CustomPaint(
                                            painter: _DialogCanvasPainter(
                                              points: widget.userPoints!,
                                              strokeColor: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    widget.userAnswer ?? "?",
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Seharusnya:",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                if (widget.userPoints != null &&
                                    widget.userPoints!.isNotEmpty)
                                  Container(
                                    height: 100,
                                    width: 140,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.correctAnswer ?? "!",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 80,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                              'KGPrimaryDots', // If they have it, else it fallbacks
                                          height: 1.0,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    widget.correctAnswer ?? "!",
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Owel Video
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 274, // Sama dengan tinggi natural papan tulis
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              if (_isInitialized) {
                                final currentCtrl = _isEvaluating 
                                    ? _thinkingController 
                                    : (_isSpeaking ? _speakingController : _idleController);
                                if (currentCtrl != null) {
                                  if (currentCtrl.value.isPlaying) {
                                    currentCtrl.pause();
                                  } else {
                                    currentCtrl.play();
                                  }
                                }
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_isInitialized &&
                                    _speakingController != null &&
                                    _idleController != null &&
                                    _thinkingController != null)
                                  SizedBox.expand(
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width:
                                            (_isEvaluating 
                                                        ? _thinkingController! 
                                                        : (_isSpeaking
                                                            ? _speakingController!
                                                            : _idleController!))
                                                    .value
                                                    .size
                                                    .width >
                                                0
                                            ? (_isEvaluating 
                                                      ? _thinkingController! 
                                                      : (_isSpeaking
                                                          ? _speakingController!
                                                          : _idleController!))
                                                  .value
                                                  .size
                                                  .width
                                            : 1600,
                                        height:
                                            (_isEvaluating 
                                                        ? _thinkingController! 
                                                        : (_isSpeaking
                                                            ? _speakingController!
                                                            : _idleController!))
                                                    .value
                                                    .size
                                                    .height >
                                                0
                                            ? (_isEvaluating 
                                                      ? _thinkingController! 
                                                      : (_isSpeaking
                                                          ? _speakingController!
                                                          : _idleController!))
                                                  .value
                                                  .size
                                                  .height
                                            : 900,
                                        child: VideoPlayer(
                                          _isEvaluating 
                                              ? _thinkingController! 
                                              : (_isSpeaking
                                                  ? _speakingController!
                                                  : _idleController!),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.blue,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    if (_isInitialized)
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.replay_rounded),
                          label: const Text("Putar Ulang"),
                          onPressed: () async {
                            _idleController?.pause();
                            _speakingController!.seekTo(Duration.zero);
                            _speakingController!.play();
                            if (mounted)
                              setState(() {
                                _isSpeaking = true;
                              });

                            if (_resolvedFeedback != null &&
                                _resolvedFeedback!.isNotEmpty) {
                              Get.find<TtsService>().stop();
                              if (mounted)
                                setState(() {
                                  _canClose = false;
                                });
                              await Get.find<TtsService>().speakAndWait(
                                _resolvedFeedback!,
                              );
                              if (mounted) {
                                setState(() {
                                  _canClose = true;
                                  _isSpeaking = false;
                                });
                                _speakingController?.pause();
                                _idleController?.seekTo(Duration.zero);
                                _idleController?.play();
                              }
                            } else {
                              if (mounted)
                                setState(() {
                                  _isSpeaking = false;
                                });
                              _speakingController?.pause();
                              _idleController?.play();
                            }
                          },
                        ),
                      ),
                    if (_isInitialized) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canClose
                              ? Colors.blue.shade600
                              : Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: _isEvaluating 
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                              ),
                        label: Text(
                          _isEvaluating ? "Memeriksa..." : "Mengerti",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: (!_canClose || _isEvaluating)
                            ? null
                            : () {
                                _speakingController?.pause();
                                _idleController?.pause();
                                _thinkingController?.pause();
                                tts.stop();
                                Get.back();
                                if (widget.onClose != null) widget.onClose!();
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogCanvasPainter extends CustomPainter {
  final List<Offset?> points;
  final Color strokeColor;
  _DialogCanvasPainter({
    required this.points,
    this.strokeColor = Colors.redAccent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Temukan bounding box (batas terluar dari coretan)
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    bool hasPoints = false;

    for (final p in points) {
      if (p != null) {
        if (p.dx < minX) minX = p.dx;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dy > maxY) maxY = p.dy;
        hasPoints = true;
      }
    }

    if (!hasPoints) return;

    // Tambahkan sedikit margin/padding di bounding box
    double width = (maxX - minX);
    double height = (maxY - minY);
    if (width == 0) width = 1;
    if (height == 0) height = 1;

    // Kita akan fit bounding box ini ke dalam ukuran 'size' kanvas
    final double padding = 20.0;
    final double scaleX = (size.width - padding * 2) / width;
    final double scaleY = (size.height - padding * 2) / height;
    final double scale = math
        .min(scaleX, scaleY)
        .clamp(0.1, 5.0); // Limit scale biar nggak kekecilan/kegedean

    // Titik pusat coretan vs titik pusat kanvas
    final double cx = minX + width / 2;
    final double cy = minY + height / 2;
    final double targetCx = size.width / 2;
    final double targetCy = size.height / 2;

    canvas.save();
    // Geser ke titik tengah kanvas
    canvas.translate(targetCx, targetCy);
    // Skalakan coretan agar fit
    canvas.scale(scale, scale);
    // Geser kembali titik pusat coretan ke 0,0 sebelum diposisikan
    canvas.translate(-cx, -cy);

    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth =
          14.0 /
          scale // Sesuaikan ketebalan garis dengan skalanya
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    Path path = Path();
    bool newSubpath = true;
    for (final p in points) {
      if (p == null) {
        newSubpath = true;
      } else {
        if (newSubpath) {
          path.moveTo(p.dx, p.dy);
          newSubpath = false;
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
    }
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DialogCanvasPainter old) =>
      old.points != points || old.strokeColor != strokeColor;
}
