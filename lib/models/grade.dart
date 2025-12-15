class Grade {
  final String id;
  final String studentId;
  final String studentName;
  final String subject;
  final String teacherId;
  final String teacherName;
  final int assignment;
  final int midTerm;
  final int finalExam;
  final int finalScore;
  final String predicate;
  final String semester;
  final String academicYear;

  Grade({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.assignment,
    required this.midTerm,
    required this.finalExam,
    required this.finalScore,
    required this.predicate,
    required this.semester,
    required this.academicYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'subject': subject,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'assignment': assignment,
      'midTerm': midTerm,
      'finalExam': finalExam,
      'finalScore': finalScore,
      'predicate': predicate,
      'semester': semester,
      'academicYear': academicYear,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'],
      studentId: map['studentId'],
      studentName: map['studentName'],
      subject: map['subject'],
      teacherId: map['teacherId'],
      teacherName: map['teacherName'],
      assignment: map['assignment'],
      midTerm: map['midTerm'],
      finalExam: map['finalExam'],
      finalScore: map['finalScore'],
      predicate: map['predicate'],
      semester: map['semester'],
      academicYear: map['academicYear'],
    );
  }

  static String calculatePredicate(int score) {
    if (score >= 85) return 'A';
    if (score >= 75) return 'B';
    if (score >= 65) return 'C';
    return 'D';
  }

  static int calculateFinalScore(int assignment, int midTerm, int finalExam) {
    return ((assignment * 0.3) + (midTerm * 0.3) + (finalExam * 0.4)).round();
  }
}