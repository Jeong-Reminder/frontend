class Admin {
  final String studentId;
  final String? password;
  final String name;
  final int level;
  final String status;
  final String userRole;

  Admin({
    required this.studentId,
    this.password,
    required this.name,
    required this.level,
    required this.status,
    required this.userRole,
  });

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
}
