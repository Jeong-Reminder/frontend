class Admin {
  String studentId;
  String? password;
  String name;
  int level;
  String status;
  final String userRole;

  Admin({
    required this.studentId,
    this.password,
    required this.name,
    required this.level,
    required this.status,
    required this.userRole,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      studentId: json['studentId'],
      name: json['name'],
      level: json['level'],
      status: json['status'],
      userRole: json['userRole'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'password': password,
      'name': name,
      'level': level,
      'status': status,
      'userRole': userRole,
    };
  }

  @override
  String toString() {
    return 'studentId: $studentId, name: $name, level: $level, status: $status, userRole: $userRole';
  }
}
