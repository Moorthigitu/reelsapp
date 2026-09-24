import 'package:flutter/material.dart';
import '../../models/reel_model.dart';

class ReelBottomInfo extends StatefulWidget {
  final ReelModel reel;

  const ReelBottomInfo({
    super.key,
    required this.reel,
  });

  @override
  State<ReelBottomInfo> createState() => _ReelBottomInfoState();
}

class _ReelBottomInfoState extends State<ReelBottomInfo> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Username & Follow button
        Row(
          children: [
            Text(
              '@${widget.reel.username}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [
                  Shadow(color: Colors.black87, blurRadius: 4),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.verified,
              color: Colors.blueAccent,
              size: 16,
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: const Text(
                'Follow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Caption with Expand toggle
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.reel.caption,
                maxLines: _isExpanded ? 10 : 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                  shadows: [
                    Shadow(color: Colors.black87, blurRadius: 4),
                  ],
                ),
              ),
              if (widget.reel.caption.length > 60 && !_isExpanded)
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    'more',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Audio Info Ticker
        Row(
          children: [
            const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Text(
                  widget.reel.audioTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(color: Colors.black87, blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
