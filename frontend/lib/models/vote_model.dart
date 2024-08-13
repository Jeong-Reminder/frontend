class Vote {
  String? subjectTitle;
  bool? repetition;
  bool? additional;
  int? announcementId;
  String? endTime;
  List<int>? voteItemIds;

  Vote({
    required this.subjectTitle,
    required this.repetition,
    required this.additional,
    required this.announcementId,
    required this.endTime,
    this.voteItemIds,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      subjectTitle: json['subjectTitle'],
      repetition: json['repetition'],
      additional: json['additional'],
      announcementId: json['announcementId'],
      endTime: json['endTime'],
      // 전달받은 json 맵에서 각 필드를 추출하여 Vote 객체 생성
      // voteItemIds는 List<dynamic> 형식으로 전달될 수 있기 때문에, 이를 List<int>로 변환하는 작업을 수행
      voteItemIds: (json['voteItemIds'] as List<dynamic>?)
          ?.map((item) => item as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectTitle': subjectTitle,
      'repetition': repetition,
      'additional': additional,
      'announcementId': announcementId,
      'endTime': endTime,

      // voteItemIds가 null이 아닐 때만 voteItemIds 필드를 JSON에 포함
      // voteItemIds 리스트의 각 항목을 정수(int)로 변환하여 JSON 리스트로 생성
      if (voteItemIds != null)
        'voteItemIds': voteItemIds!.map((item) => item.toInt()).toList(),
    };
  }
}
