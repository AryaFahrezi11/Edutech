import 'dart:async';
import 'dart:convert';
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
  final String? avatarImageUrl;
  final VoidCallback? onClose;

  const BuGuruAvatarDialog({
    super.key,
    this.videoUrl,
    this.talkId,
    this.voiceFeedback,
    this.avatarImageUrl,
    this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    String? videoUrl,
    String? talkId,
    String? voiceFeedback,
    String? avatarImageUrl,
    VoidCallback? onClose,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BuGuruAvatarDialog(
        videoUrl: videoUrl,
        talkId: talkId,
        voiceFeedback: voiceFeedback,
        avatarImageUrl: avatarImageUrl,
        onClose: onClose,
      ),
    );
  }

  @override
  State<BuGuruAvatarDialog> createState() => _BuGuruAvatarDialogState();
}

class _BuGuruAvatarDialogState extends State<BuGuruAvatarDialog> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      await _loadVideoUrl(widget.videoUrl!);
    } else if (widget.talkId != null && widget.talkId!.isNotEmpty) {
      print("📡 Polling status D-ID untuk talk_id: ${widget.talkId}");
      _pollTalkStatus(widget.talkId!);
    } else {
      print("⚠️ Warning: widget.videoUrl and talkId are NULL or EMPTY!");
      _fallbackToTts();
    }
  }

  Future<void> _pollTalkStatus(String talkId) async {
    final statusUrl = "${ApiEndpoints.baseUrl}/avatar/talk/$talkId";
    int polls = 0;
    while (polls < 30 && mounted && !_isInitialized && !_hasError) {
      polls++;
      await Future.delayed(const Duration(seconds: 2));
      try {
        final res = await http.get(Uri.parse(statusUrl)).timeout(const Duration(seconds: 10));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final status = (data['status'] ?? '').toString().toLowerCase();
          print("📡 Polling #$polls talk_id $talkId: status = $status");

          final resultUrl = data['result_url'] ?? data['video_url'] ?? data['url'];

          if ((status == 'done' || status == 'success' || status == 'completed') && resultUrl != null) {
            await _loadVideoUrl(resultUrl as String);
            break;
          } else if (status == 'error' || status == 'rejected') {
            print("❌ D-ID talk status returned error: ${data['error']}");
            _fallbackToTts();
            break;
          }
        }
      } catch (e) {
        print("❌ Error polling talk status: $e");
      }
    }
    if (!_isInitialized && !_hasError && mounted) {
      print("⚠️ Timeout polling talk status, falling back to TTS");
      _fallbackToTts();
    }
  }

  Future<void> _loadVideoUrl(String url) async {
    try {
      print("🎬 Memuat video animasi D-ID: $url");
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await _controller!.initialize().timeout(const Duration(seconds: 30));

      _controller!.addListener(() {
        if (mounted) setState(() {});
      });

      setState(() {
        _isInitialized = true;
      });

      await _controller!.setVolume(1.0);
      await _controller!.setLooping(false);

      try {
        await _controller!.play();
      } catch (playError) {
        print("⚠️ Direct play error: $playError");
      }

      // Pastikan memutar otomatis tanpa perlu tombol manual
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _controller != null && !_controller!.value.isPlaying) {
          _controller!.play();
        }
      });
    } catch (e) {
      print("❌ Error load video avatar D-ID: $e");
      _fallbackToTts();
    }
  }

  void _fallbackToTts() {
    if (mounted) {
      setState(() {
        _hasError = true;
      });
      if (widget.voiceFeedback != null && widget.voiceFeedback!.isNotEmpty) {
        Get.find<TtsService>().speak(widget.voiceFeedback!);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultAvatar = widget.avatarImageUrl ??
        "https://files.catbox.moe/cvyv9s.jpg";

    final isWaitingForVideo = (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) ||
        (widget.talkId != null && widget.talkId!.isNotEmpty);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
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
                      const Icon(Icons.psychology_rounded, color: Colors.blue, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        "Evaluasi Bu Guru Ani",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () {
                      _controller?.pause();
                      Get.back();
                      if (widget.onClose != null) widget.onClose!();
                    },
                  )
                ],
              ),
              const SizedBox(height: 12),

              // Container Video / Foto Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 260,
                  height: 260,
                  color: Colors.blue.shade50,
                  child: GestureDetector(
                    onTap: () {
                      if (_isInitialized && _controller != null) {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isInitialized && _controller != null)
                          AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio > 0
                                ? _controller!.value.aspectRatio
                                : 1.0,
                            child: VideoPlayer(_controller!),
                          )
                        else
                          Image.network(
                            defaultAvatar,
                            width: 260,
                            height: 260,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 100, color: Colors.blue),
                          ),

                        // Loading Overlay HANYA jika ada video/talk ID D-ID yang sedang di-load/poll dari jaringan
                        if (isWaitingForVideo && !_isInitialized && !_hasError)
                          Container(
                            color: Colors.black.withValues(alpha: 0.6),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(height: 12),
                                Text(
                                  "Memuat Video D-ID...",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Speech Bubble (Teks Evaluasi Suara)
              if (widget.voiceFeedback != null && widget.voiceFeedback!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.shade300, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.record_voice_over_rounded, color: Colors.amber, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "\"${widget.voiceFeedback}\"",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber.shade900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  if (_isInitialized && _controller != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text("Putar Ulang"),
                        onPressed: () {
                          _controller!.seekTo(Duration.zero);
                          _controller!.play();
                        },
                      ),
                    ),
                  if (_isInitialized && _controller != null) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                      label: const Text("Mengerti", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        _controller?.pause();
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
    );
  }
}
