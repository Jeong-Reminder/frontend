class Vote {
  int? id;
  String? subjectTitle;
  bool? repetition;
  bool? additional;
  int? announcementId;
  String? endDateTime;
  List<int>? voteItemIds;
  List<Map<String, dynamic>>? voteItems;

  Vote({
    this.id,
    required this.subjectTitle,
    required this.repetition,
    required this.additional,
    required this.announcementId,
    required this.endDateTime,
    this.voteItemIds,
    this.voteItems,
  });

  // 데이터를 가져올 때 사용
  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      subjectTitle: json['subjectTitle'],
      repetition: json['repetition'],
      additional: json['additional'],
      announcementId: json['announcementId'],
      endDateTime: json['endDateTime'] as String?,
      voteItemIds: (json['voteItemIds'] as List<dynamic>?)
          ?.map((item) => item as int)
          .toList(),

      // voteItems를 Map<String, dynamic>으로 변환
      voteItems: (json['voteItems'] as List<dynamic>?)
          ?.map((item) => item as Map<String, dynamic>)
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
      'endDateTime': endDateTime,

      // voteItemIds가 null이 아닐 때만 voteItemIds 필드를 JSON에 포함
      // voteItemIds 리스트의 각 항목을 정수(int)로 변환하여 JSON 리스트로 생성
      if (voteItemIds != null)
        'voteItemIds': voteItemIds!.map((item) => item.toInt()).toList(),

      if (voteItems != null) 'voteItems': voteItems,
    };
  }

  @override
  String toString() {
    return '{id: $id, subjectTitle: $subjectTitle, repetition: $repetition, additional: $additional, announcementId: $announcementId, endDateTime: $endDateTime, voteItemIds: $voteItemIds}';
  }
}
