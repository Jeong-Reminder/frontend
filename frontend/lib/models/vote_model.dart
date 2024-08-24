class Vote {
  int? id;
  String? subjectTitle;
  bool? repetition;
  bool? additional;
  int? announcementId;
  String? endDateTime;
  bool? voteEnded;
  bool? hasVoted;
  List<int>? voteItemIds;
  List<Map<String, dynamic>>? voteItems;

  Vote({
    this.id,
    required this.subjectTitle,
    required this.repetition,
    required this.additional,
    required this.announcementId,
    required this.endDateTime,
    this.voteEnded,
    this.hasVoted,
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

      // endTime이 List<int> 형식으로 전달되는 경우, 이를 DateTime으로 변환 후 String으로 변환
      endDateTime: json['endDateTime']
          as String?, // DateTime 객체를 ISO 8601 형식의 String으로 변환

      voteEnded: json['voteEnded'],

      hasVoted: json['hasVoted'],


      // 전달받은 json 맵에서 각 필드를 추출하여 Vote 객체 생성
      // voteItemIds는 List<dynamic> 형식으로 전달될 수 있기 때문에, 이를 List<int>로 변환하는 작업을 수행
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
    };
  }
}
