import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/reel_model.dart';
import 'heart_animation_widget.dart';
import 'reel_right_sidebar.dart';
import 'reel_bottom_info.dart';

class ReelPlayerWidget extends StatefulWidget {
  final ReelModel reel;
  final VideoPlayerController? controller;
  final bool isCurrentPage;
  final bool isMuted;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleLike;
  final VoidCallback onOpenComments;
  final VoidCallback onShare;

  const ReelPlayerWidget({
    super.key,
    required this.reel,
    required this.controller,
    required this.isCurrentPage,
    required this.isMuted,
    required this.onToggleMute,
    required this.onToggleLike,
    required this.onOpenComments,
    required this.onShare,
  });

  @override
  State<ReelPlayerWidget> createState() => _ReelPlayerWidgetState();
}

class _ReelPlayerWidgetState extends State<ReelPlayerWidget> {
  bool _showHeartAnimation = false;
  bool _showPlayPauseOverlay = false;
  bool _isPlaying = true;

  void _onDoubleTap() {
    setState(() {
      _showHeartAnimation = true;
    });
    widget.onToggleLike();
  }

  void _onSingleTap() {
    if (widget.controller != null && widget.controller!.value.isInitialized) {
      if (widget.controller!.value.isPlaying) {
        widget.controller!.pause();
        setState(() {
          _isPlaying = false;
          _showPlayPauseOverlay = true;
        });
      } else {
        widget.controller!.play();
        setState(() {
          _isPlaying = true;
          _showPlayPauseOverlay = true;
        });
      }

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showPlayPauseOverlay = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isInitialized =
        widget.controller != null && widget.controller!.value.isInitialized;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video View or Loading Placeholder
        GestureDetector(
          onTap: _onSingleTap,
          onDoubleTap: _onDoubleTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (isInitialized)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: widget.controller!.value.size.width,
                      height: widget.controller!.value.size.height,
                      child: VideoPlayer(widget.controller!),
                    ),
                  ),
                )
              else
                _buildLoadingState(),

              // Dark top & bottom gradients for overlay readability
              _buildGradientOverlays(),

              // Play / Pause Icon Overlay when tapped
              if (_showPlayPauseOverlay)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),

              // Double Tap Heart Burst Animation
              if (_showHeartAnimation)
                Center(
                  child: HeartAnimationWidget(
                    isAnimating: _showHeartAnimation,
                    onEnd: () {
                      setState(() {
                        _showHeartAnimation = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 110,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Top App Bar Controls
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Reels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      widget.isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: widget.onToggleMute,
                  ),
                  const IconButton(
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                    onPressed: null,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Bottom Left Creator Info & Caption
        Positioned(
          left: 16,
          bottom: 24,
          right: 80,
          child: ReelBottomInfo(reel: widget.reel),
        ),

        // Right Action Sidebar
        Positioned(
          right: 12,
          bottom: 24,
          child: ReelRightSidebar(
            reel: widget.reel,
            onLikeToggle: widget.onToggleLike,
            onCommentTap: widget.onOpenComments,
            onShareTap: widget.onShare,
          ),
        ),

        // Bottom Video Progress Line
        if (isInitialized)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              widget.controller!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white30,
                backgroundColor: Colors.white10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Sleek dark gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141414), Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Subtle top buffering line (no text, no large spinner)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              color: Colors.redAccent.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlays() {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Top gradient
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 140,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Bottom gradient
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
