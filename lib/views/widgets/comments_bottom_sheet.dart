import 'package:flutter/material.dart';
import '../../models/reel_model.dart';
import '../../models/comment_model.dart';
import '../../services/storage_service.dart';

class CommentsBottomSheet extends StatefulWidget {
  final ReelModel reel;
  final Function(int newCount) onCommentAdded;

  const CommentsBottomSheet({
    super.key,
    required this.reel,
    required this.onCommentAdded,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = CommentModel(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      userName: 'you_reeler',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=you_reeler',
      text: text,
      timestamp: DateTime.now(),
      likeCount: 0,
      isLiked: false,
    );

    setState(() {
      widget.reel.comments.insert(0, newComment);
      widget.reel.commentCount = widget.reel.comments.length;
    });

    _commentController.clear();
    widget.onCommentAdded(widget.reel.commentCount);

    // Save to local storage
    await StorageService.saveComments(widget.reel.id, widget.reel.comments);
  }

  void _toggleCommentLike(CommentModel comment) async {
    setState(() {
      comment.isLiked = !comment.isLiked;
      if (comment.isLiked) {
        comment.likeCount++;
      } else {
        comment.likeCount--;
      }
    });

    // Save updated comments to local storage
    await StorageService.saveComments(widget.reel.id, widget.reel.comments);
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header Bar handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.reel.comments.length} Comments',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade200, height: 1),

          // Comments List
          Expanded(
            child: widget.reel.comments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.reel.comments.length,
                    itemBuilder: (context, index) {
                      final comment = widget.reel.comments[index];
                      return _buildCommentTile(comment);
                    },
                  ),
          ),

          // Comment Input Field
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: Colors.grey.shade400,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No comments yet',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Be the first to leave a comment!',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.purple.shade600,
            child: Text(
              comment.userName.isNotEmpty
                  ? comment.userName[0].toUpperCase()
                  : 'A',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(comment.timestamp),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _toggleCommentLike(comment),
            child: Column(
              children: [
                Icon(
                  comment.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: comment.isLiked ? Colors.redAccent : Colors.grey.shade400,
                  size: 16,
                ),
                if (comment.likeCount > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${comment.likeCount}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (_) => _addComment(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.redAccent),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }
}
