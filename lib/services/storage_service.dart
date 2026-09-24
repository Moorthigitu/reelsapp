import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reel_model.dart';
import '../models/comment_model.dart';

class StorageService {
  static const String _keyLikedPrefix = 'reel_liked_';
  static const String _keyLikeCountPrefix = 'reel_like_count_';
  static const String _keyCommentsPrefix = 'reel_comments_';

  // Load saved state into initial list of reels
  static Future<List<ReelModel>> applySavedStates(List<ReelModel> reels) async {
    final prefs = await SharedPreferences.getInstance();

    for (var reel in reels) {
      // Restore Like state
      final likedKey = '$_keyLikedPrefix${reel.id}';
      if (prefs.containsKey(likedKey)) {
        reel.isLiked = prefs.getBool(likedKey) ?? false;
      }

      // Restore Like count
      final countKey = '$_keyLikeCountPrefix${reel.id}';
      if (prefs.containsKey(countKey)) {
        reel.likeCount = prefs.getInt(countKey) ?? reel.likeCount;
      }

      // Restore Comments
      final commentsKey = '$_keyCommentsPrefix${reel.id}';
      if (prefs.containsKey(commentsKey)) {
        final String? rawJson = prefs.getString(commentsKey);
        if (rawJson != null && rawJson.isNotEmpty) {
          try {
            final List<dynamic> list = jsonDecode(rawJson);
            reel.comments = list
                .map((e) => CommentModel.fromJson(Map<String, dynamic>.from(e)))
                .toList();
            reel.commentCount = reel.comments.length;
          } catch (e) {
            // fallback if decode error
          }
        }
      }
    }

    return reels;
  }

  // Persist like state & count
  static Future<void> saveLikeState(String reelId, bool isLiked, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_keyLikedPrefix$reelId', isLiked);
    await prefs.setInt('$_keyLikeCountPrefix$reelId', count);
  }

  // Persist comments list
  static Future<void> saveComments(String reelId, List<CommentModel> comments) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = comments.map((c) => c.toJson()).toList();
    await prefs.setString('$_keyCommentsPrefix$reelId', jsonEncode(jsonList));
  }
}
