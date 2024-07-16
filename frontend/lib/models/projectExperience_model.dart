class ProjectExperience {
  String experienceName;
  String experienceRole;
  String experienceContent;
  String experienceGithub;
  String experienceJob;
  String experienceDate;

  ProjectExperience({
    required this.experienceName,
    required this.experienceRole,
    required this.experienceContent,
    required this.experienceGithub,
    required this.experienceJob,
    required this.experienceDate,
  });

  factory ProjectExperience.fromJson(Map<String, dynamic> json) {
    return ProjectExperience(
      experienceName: json['experienceName'],
      experienceRole: json['experienceRole'],
      experienceContent: json['experienceContent'],
      experienceGithub: json['experienceGithub'],
      experienceJob: json['experienceJob'],
      experienceDate: json['experienceDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experienceName': experienceName,
      'experienceRole': experienceRole,
      'experienceContent': experienceContent,
      'experienceGithub': experienceGithub,
      'experienceJob': experienceJob,
      'experienceDate': experienceDate,
    };
  }

  @override
  String toString() {
    return 'experienceName: $experienceName, experienceRole: $experienceRole, experienceContent: $experienceContent, experienceGithub: $experienceGithub, experienceJob: $experienceJob, experienceDate: $experienceDate ';
  }
}
