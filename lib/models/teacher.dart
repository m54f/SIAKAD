class Teacher {
  final String id;
  final String nip;
  final String name;
  final String subject;

  Teacher({
    required this.id,
    required this.nip,
    required this.name,
    required this.subject,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nip': nip,
      'name': name,
      'subject': subject,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      nip: map['nip'],
      name: map['name'],
      subject: map['subject'],
    );
  }
}