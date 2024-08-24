class TeamApply {
  int? id;
  String applicationContent;

  TeamApply({
    required this.applicationContent,
    this.id,
  });

  factory TeamApply.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;

    return TeamApply(
      id: id,
      applicationContent: json['applicationContent'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'applicationContent': applicationContent,
    };

    return data;
  }

  @override
  String toString() {
    return 'applicationContent: $applicationContent, id: $id';
  }
}
