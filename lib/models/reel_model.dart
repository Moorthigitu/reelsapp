import 'comment_model.dart';

class ReelModel {
  final String id;
  final String videoUrl;
  final String username;
  final String userAvatar;
  final String caption;
  final String audioTitle;
  int likeCount;
  int commentCount;
  bool isLiked;
  List<CommentModel> comments;

  ReelModel({
    required this.id,
    required this.videoUrl,
    required this.username,
    required this.userAvatar,
    required this.caption,
    required this.audioTitle,
    required this.likeCount,
    required this.commentCount,
    this.isLiked = false,
    List<CommentModel>? comments,
  }) : comments = comments ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'username': username,
      'userAvatar': userAvatar,
      'caption': caption,
      'audioTitle': audioTitle,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isLiked': isLiked,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      username: json['username'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      caption: json['caption'] ?? '',
      audioTitle: json['audioTitle'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}
