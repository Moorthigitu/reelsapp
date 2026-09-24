import 'package:flutter/material.dart';
import '../../models/reel_model.dart';

class ReelRightSidebar extends StatefulWidget {
  final ReelModel reel;
  final VoidCallback onLikeToggle;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;

  const ReelRightSidebar({
    super.key,
    required this.reel,
    required this.onLikeToggle,
    required this.onCommentTap,
    required this.onShareTap,
  });

  @override
  State<ReelRightSidebar> createState() => _ReelRightSidebarState();
}

class _ReelRightSidebarState extends State<ReelRightSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _discController;

  @override
  void initState() {
    super.initState();
    _discController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _discController.dispose();
    super.dispose();
  }

  String _formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Avatar with Follow badge
        _buildAvatar(),
        const SizedBox(height: 20),

        // Like Button
        _buildIconButton(
          icon: widget.reel.isLiked
              ? Icons.favorite
              : Icons.favorite_outline,
          color: widget.reel.isLiked ? Colors.redAccent : Colors.white,
          label: _formatCount(widget.reel.likeCount),
          onTap: widget.onLikeToggle,
        ),
        const SizedBox(height: 18),

        // Comment Button
        _buildIconButton(
          icon: Icons.chat_bubble_outline_rounded,
          color: Colors.white,
          label: _formatCount(widget.reel.commentCount),
          onTap: widget.onCommentTap,
        ),
        const SizedBox(height: 18),

        // Share Button
        _buildIconButton(
          icon: Icons.send_rounded,
          color: Colors.white,
          label: 'Share',
          onTap: widget.onShareTap,
        ),
        const SizedBox(height: 18),

        // Options / More
        _buildIconButton(
          icon: Icons.more_vert,
          color: Colors.white,
          label: '',
          onTap: () {},
        ),
        const SizedBox(height: 20),

        // Spinning Music Disc
        _buildSpinningDisc(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.pink, Colors.orange],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              child: Text(
                widget.reel.username.isNotEmpty
                    ? widget.reel.username[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpinningDisc() {
    return RotationTransition(
      turns: _discController,
      child: Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade700, width: 2),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                Colors.grey,
                Colors.black,
                Colors.grey,
                Colors.black,
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
