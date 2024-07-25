class MakeTeam {
  int? id; // 선택적 필드
  int? memberId; // 선택적 필드
  String recruitmentCategory;
  String recruitmentTile;
  String recruitmentContent;
  int studentCount;
  String hopeField;
  String kakaoUrl;
  String recruitmentStatus;
  String endTime;
  int announcementId;

  MakeTeam({
    this.id,
    this.memberId,
    required this.recruitmentCategory,
    required this.recruitmentTile,
    required this.recruitmentContent,
    required this.studentCount,
    required this.hopeField,
    required this.kakaoUrl,
    required this.recruitmentStatus,
    required this.endTime,
    required this.announcementId,
  });

  factory MakeTeam.fromJson(Map<String, dynamic> json) {
    // JSON 데이터에서 id와 memberId를 추출
    final id = json['id'] as int?;
    final memberId = json['memberId'] as int?;

    return MakeTeam(
      id: id,
      memberId: memberId,
      recruitmentCategory: json['recruitmentCategory'] as String,
      recruitmentTile: json['recruitmentTile'] as String,
      recruitmentContent: json['recruitmentContent'] as String,
      studentCount: json['studentCount'] as int,
      hopeField: json['hopeField'] as String,
      kakaoUrl: json['kakaoUrl'] as String,
      recruitmentStatus: json['recruitmentStatus'] as String,
      endTime: json['endTime'] as String,
      announcementId: json['announcementId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'recruitmentCategory': recruitmentCategory,
      'recruitmentTile': recruitmentTile,
      'recruitmentContent': recruitmentContent,
      'studentCount': studentCount,
      'hopeField': hopeField,
      'kakaoUrl': kakaoUrl,
      'recruitmentStatus': recruitmentStatus,
      'endTime': endTime,
      'announcementId': announcementId,
    };

    // id 필드를 백엔드로 보내지 않도록 함
    if (memberId != null) {
      data['memberId'] = memberId;
    }

    return data;
  }

  @override
  String toString() {
    return 'id: $id, memberId: $memberId, recruitmentCategory: $recruitmentCategory, recruitmentTile: $recruitmentTile, recruitmentContent: $recruitmentContent, studentCount: $studentCount, hopeField: $hopeField, kakaoUrl: $kakaoUrl, recruitmentStatus: $recruitmentStatus, endTime: $endTime, announcementId: $announcementId';
  }
}
