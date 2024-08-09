class Board {
  int? id;
  String? announcementCategory;
  String? announcementTitle;
  String? announcementContent;
  bool? announcementImportant;
  bool? visible;
  int? announcementLevel;

  Board({
    this.id,
    required this.announcementCategory,
    required this.announcementTitle,
    required this.announcementContent,
    required this.announcementImportant,
    required this.visible,
    required this.announcementLevel,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      announcementCategory: json['announcementCategory'],
      announcementTitle: json['announcementTitle'],
      announcementContent: json['announcementContent'],
      announcementImportant: json['announcementImportant'],
      visible: json['visible'],
      announcementLevel: json['announcementLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'announcementCategory': announcementCategory,
      'announcementTitle': announcementTitle,
      'announcementContent': announcementContent,
      'announcementImportant': announcementImportant,
      'visible': visible,
      'announcementLevel': announcementLevel,
    };
  }

  @override
  String toString() {
    return 'id: $id, announcementCategory: $announcementCategory, announcementTitle: $announcementTitle, announcementContent: $announcementContent, announcementImportant: $announcementImportant, visible: $visible, announcementLevel: $announcementLevel';
  }
}
