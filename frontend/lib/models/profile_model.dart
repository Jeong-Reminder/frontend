class Profile {
  final String? memberName;
  int? memberLevel;
  String? hopeJob;
  String? githubLink;
  String? developmentField;
  String? developmentTool;

  Profile({
    this.memberName,
    this.memberLevel,
    required this.hopeJob,
    required this.githubLink,
    required this.developmentField,
    required this.developmentTool,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      memberName: json['memberName'],
      memberLevel: json['memberLevel'],
      hopeJob: json['hopeJob'],
      githubLink: json['githubLink'],
      developmentField: json['developmentField'],
      developmentTool: json['developmentTool'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hopeJob': hopeJob,
      'githubLink': githubLink,
      'developmentField': developmentField,
      'developmentTool': developmentTool,
    };
  }

  @override
  String toString() {
    return 'hopeJob: $hopeJob, githubLink: $githubLink, developmentField: $developmentField, developmentTool: $developmentTool';
  }
}
