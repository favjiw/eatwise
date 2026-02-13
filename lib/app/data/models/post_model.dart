class PostModel {
  int? id;
  int? userId;
  String? content;
  int? likesCount;
  String? createdAt;
  String? userName;

  PostModel({
    this.id,
    this.userId,
    this.content,
    this.likesCount,
    this.createdAt,
    this.userName,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'],
    userId: json['user_id'],
    content: json['content'],
    likesCount: json['likes_count'] ?? 0,
    createdAt: json['created_at'],
    userName: json['user'] != null ? json['user']['name'] : 'Anonymous',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "content": content,
    "likes_count": likesCount,
  };
}