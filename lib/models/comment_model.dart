class CommentModel {
  final String id;
  final String userName;
  final String userAvatar;
  final String text;
  final DateTime timestamp;
  int likeCount;
  bool isLiked;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.timestamp,
    this.likeCount = 0,
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userAvatar': userAvatar,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'likeCount': likeCount,
      'isLiked': isLiked,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? 'Anonymous',
      userAvatar: json['userAvatar'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }
}
