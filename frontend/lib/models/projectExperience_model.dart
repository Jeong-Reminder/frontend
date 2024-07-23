class ProjectExperience {
  int? id; // 선택적 필드
  int? memberId; // 선택적 필드
  String experienceName;
  String experienceRole;
  String experienceContent;
  String experienceGithub;
  String experienceJob;
  String experienceDate;

  ProjectExperience({
    this.id,
    this.memberId,
    required this.experienceName,
    required this.experienceRole,
    required this.experienceContent,
    required this.experienceGithub,
    required this.experienceJob,
    required this.experienceDate,
  });

  factory ProjectExperience.fromJson(Map<String, dynamic> json) {
    // JSON 데이터에서 id와 memberId를 추출
    final id = json['id'] as int?;
    final memberId = json['memberId'] as int?;

    return ProjectExperience(
      id: id,
      memberId: memberId,
      experienceName: json['experienceName'] as String,
      experienceRole: json['experienceRole'] as String,
      experienceContent: json['experienceContent'] as String,
      experienceGithub: json['experienceGithub'] as String,
      experienceJob: json['experienceJob'] as String,
      experienceDate: json['experienceDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'experienceName': experienceName,
      'experienceRole': experienceRole,
      'experienceContent': experienceContent,
      'experienceGithub': experienceGithub,
      'experienceJob': experienceJob,
      'experienceDate': experienceDate,
    };

    // id 필드를 백엔드로 보내지 않도록 함
    if (memberId != null) {
      data['memberId'] = memberId;
    }

    return data;
  }

  @override
  String toString() {
    return 'id: $id, memberId: $memberId, experienceName: $experienceName, experienceRole: $experienceRole, experienceContent: $experienceContent, experienceGithub: $experienceGithub, experienceJob: $experienceJob, experienceDate: $experienceDate';
  }
}
