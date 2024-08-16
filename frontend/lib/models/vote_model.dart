class Vote {
  int? id;
  String? subjectTitle;
  bool? repetition;
  bool? additional;
  int? announcementId;
  String? endTime;
  List<int>? voteItemIds;

  Vote({
    this.id,
    required this.subjectTitle,
    required this.repetition,
    required this.additional,
    required this.announcementId,
    required this.endTime,
    this.voteItemIds,
  });

  // 데이터를 가져올 때 사용
  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      subjectTitle: json['subjectTitle'],
      repetition: json['repetition'],
      additional: json['additional'],
      announcementId: json['announcementId'],

      // endTime이 List<int> 형식으로 전달되는 경우, 이를 DateTime으로 변환 후 String으로 변환
      endTime: json['endTime']
              is List<dynamic> // json['endTime']이 List<dynamic> 타입인지 확인
          ? DateTime(
              json['endTime'][0],
              json['endTime'][1],
              json['endTime'][2],
              json['endTime'][3],
              json['endTime'][4],
            ).toIso8601String() // List<int>로 변환하고 DateTime 객체로 변환
          : json['endTime'] as String?, // DateTime 객체를 ISO 8601 형식의 String으로 변환

      // 전달받은 json 맵에서 각 필드를 추출하여 Vote 객체 생성
      // voteItemIds는 List<dynamic> 형식으로 전달될 수 있기 때문에, 이를 List<int>로 변환하는 작업을 수행
      voteItemIds: (json['voteItemIds'] as List<dynamic>?)
          ?.map((item) => item as int)
          .toList(),
    );
  }

  // 요청 바디에 사용
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

  @override
  String toString() {
    return '{id: $id, subjectTitle: $subjectTitle, repetition: $repetition, additional: $additional, announcementId: $announcementId, endTime: $endTime, voteItemIds: $voteItemIds}';
  }
}
