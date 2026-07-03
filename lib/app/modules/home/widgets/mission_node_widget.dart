import 'package:flutter/material.dart';
import '../../../data/mission_node.dart';

/// Widget reusable untuk satu node misi di peta perjalanan.
/// Menampilkan status: completed (✅), current (pulse animasi), locked (🔒).
/// Boss node (ujian) mendapat desain khusus yang lebih besar.
class MissionNodeWidget extends StatefulWidget {
  final MissionNode node;
  final bool isCompleted;
  final bool isCurrent;
  final bool isUnlocked;
  final VoidCallback onTap;

  const MissionNodeWidget({
    Key? key,
    required this.node,
    required this.isCompleted,
    required this.isCurrent,
    required this.isUnlocked,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MissionNodeWidget> createState() => _MissionNodeWidgetState();
}

class _MissionNodeWidgetState extends State<MissionNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Hanya pulse jika ini node yang sedang aktif
    if (widget.isCurrent) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MissionNodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isCurrent && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBoss = widget.node.isBoss;
    final size = isBoss ? 82.0 : 68.0;

    return GestureDetector(
      onTap: widget.isUnlocked ? widget.onTap : _showLockedMessage,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Crown/Star untuk boss node
          if (isBoss && widget.isUnlocked) ...[
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: const Text("👑", style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: 4),
          ],

          // Node utama
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              final scale = widget.isCurrent ? _pulseAnimation.value : 1.0;
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.isUnlocked
                    ? LinearGradient(
                        colors: widget.node.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: widget.isUnlocked ? null : const Color(0xFFD4D4D8),
                border: Border.all(
                  color: widget.isCurrent
                      ? Colors.white
                      : widget.isCompleted
                          ? const Color(0xFF1CB0F6)
                          : Colors.transparent,
                  width: widget.isCurrent ? 4 : 3,
                ),
                boxShadow: [
                  if (widget.isCurrent)
                    BoxShadow(
                      color: widget.node.gradient.first.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  if (widget.isCompleted)
                    BoxShadow(
                      color: const Color(0xFF1CB0F6).withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  if (!widget.isUnlocked)
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Emoji utama atau icon status
                  if (!widget.isUnlocked)
                    Icon(Icons.lock_rounded,
                        size: isBoss ? 32 : 26,
                        color: const Color(0xFF9CA3AF))
                  else
                    Text(
                      widget.node.emoji,
                      style: TextStyle(fontSize: isBoss ? 36 : 28),
                    ),

                  // Glow ring untuk current node
                  if (widget.isCurrent)
                    Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Label node
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: widget.isCurrent
                  ? widget.node.gradient.first.withOpacity(0.15)
                  : widget.isCompleted
                      ? const Color(0xFF1CB0F6).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.node.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isBoss ? 13 : 11,
                fontWeight: FontWeight.w800,
                color: widget.isUnlocked
                    ? (widget.isCurrent
                        ? widget.node.gradient.first
                        : widget.isCompleted
                            ? const Color(0xFF1CB0F6)
                            : const Color(0xFF374151))
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),

          // Badge "MULAI!" untuk current node
          if (widget.isCurrent) ...[
            const SizedBox(height: 6),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.node.gradient),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.node.gradient.first.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  isBoss ? "⚔️ UJIAN!" : "▶ MULAI!",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text("🔒 ", style: TextStyle(fontSize: 20)),
            Expanded(
              child: Text(
                "Selesaikan misi sebelumnya dulu ya!",
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6B7280),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
