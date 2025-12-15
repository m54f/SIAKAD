class Student {
  final String id;
  final String nis;
  final String name;
  final String className;
  final String major;

  Student({
    required this.id,
    required this.nis,
    required this.name,
    required this.className,
    required this.major,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nis': nis,
      'name': name,
      'className': className,
      'major': major,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      nis: map['nis'],
      name: map['name'],
      className: map['className'],
      major: map['major'],
    );
  }
}