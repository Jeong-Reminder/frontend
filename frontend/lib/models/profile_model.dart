class Profile {
  String? hopeJob;
  String? githubLink;
  String? developmentField;
  String? developmentTool;

  Profile({
    required this.hopeJob,
    required this.githubLink,
    required this.developmentField,
    required this.developmentTool,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
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
