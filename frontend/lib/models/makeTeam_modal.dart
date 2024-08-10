class MakeTeam {
  int? id; // 선택적 필드
  int? memberId; // 선택적 필드
  String recruitmentCategory;
  String recruitmentTitle;
  String recruitmentContent;
  int studentCount;
  String hopeField;
  String kakaoUrl;
  bool recruitmentStatus;
  String endTime;
  int announcementId;

  MakeTeam({
    this.id,
    this.memberId,
    required this.recruitmentCategory,
    required this.recruitmentTitle,
    required this.recruitmentContent,
    required this.studentCount,
    required this.hopeField,
    required this.kakaoUrl,
    required this.recruitmentStatus,
    required this.endTime,
    required this.announcementId,
  });

  factory MakeTeam.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final memberId = json['memberId'] as int?;

    return MakeTeam(
      id: id,
      memberId: memberId,
      recruitmentCategory: json['recruitmentCategory'] as String,
      recruitmentTitle: json['recruitmentTitle'] as String,
      recruitmentContent: json['recruitmentContent'] as String,
      studentCount: json['studentCount'] as int,
      hopeField: json['hopeField'] as String,
      kakaoUrl: json['kakaoUrl'] as String,
      recruitmentStatus: json['recruitmentStatus'] as bool,
      endTime: json['endTime'] as String,
      announcementId: json['announcementId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'recruitmentCategory': recruitmentCategory,
      'recruitmentTitle': recruitmentTitle,
      'recruitmentContent': recruitmentContent,
      'studentCount': studentCount,
      'hopeField': hopeField,
      'kakaoUrl': kakaoUrl,
      'recruitmentStatus': recruitmentStatus,
      'endTime': endTime,
      'announcementId': announcementId,
    };

    // 요청 바디에 id를 포함하지 않음
    if (memberId != null) {
      data['memberId'] = memberId;
    }

    return data;
  }

  @override
  String toString() {
    return 'id: $id, memberId: $memberId, recruitmentCategory: $recruitmentCategory, recruitmentTitle: $recruitmentTitle, recruitmentContent: $recruitmentContent, studentCount: $studentCount, hopeField: $hopeField, kakaoUrl: $kakaoUrl, recruitmentStatus: $recruitmentStatus, endTime: $endTime, announcementId: $announcementId';
  }
}
