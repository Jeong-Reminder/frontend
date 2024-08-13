class TeamApply {
  String applicationContent;

  TeamApply({
    required this.applicationContent,
  });

  factory TeamApply.fromJson(Map<String, dynamic> json) {
    return TeamApply(
      applicationContent: json['applicationContent'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'applicationContent': applicationContent,
    };

    return data;
  }

  @override
  String toString() {
    return 'applicationContent: $applicationContent';
  }
}
