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
      voteItemIds: json['voteItemIds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectTitle': subjectTitle,
      'repetition': repetition,
      'additional': additional,
      'announcementId': announcementId,
      'endTime': endTime,
      'voteItemIds': voteItemIds,
    };
  }

  @override
  String toString() {
    return 'subjectTitle: $subjectTitle, repetition: $repetition, additional: $additional, announcementId: $announcementId. endTime: $endTime, voteItemIds: $voteItemIds';
  }
}
