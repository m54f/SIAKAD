class Schedule {
  final String id;
  final String day;
  final String time;
  final String subject;
  final String teacherId;
  final String teacherName;
  final String className;

  Schedule({
    required this.id,
    required this.day,
    required this.time,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.className,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'time': time,
      'subject': subject,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'className': className,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      day: map['day'],
      time: map['time'],
      subject: map['subject'],
      teacherId: map['teacherId'],
      teacherName: map['teacherName'],
      className: map['className'],
    );
  }
}