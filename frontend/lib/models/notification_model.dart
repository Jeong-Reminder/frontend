class NotificationModel {
  String? id;
  String? title;
  String? content;
  String? category;
  int? targetId;
  String? createAt;
  bool? read;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.targetId,
    required this.createAt,
    required this.read,
  });

  NotificationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        category = json['category'],
        targetId = json['targetId'],
        createAt = json['createAt'],
        read = json['read'];
}
