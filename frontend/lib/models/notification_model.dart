class NotificationModel {
  String? id;
  String? title;
  String? content;
  String? category;
  int? targetId;
  String? createdAt;
  bool? read;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.targetId,
    required this.createdAt,
    required this.read,
  });

  NotificationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        category = json['category'],
        targetId = json['targetId'],
        createdAt = json['createdAt'],
        read = json['read'];
}
