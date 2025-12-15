class Announcement {
  final String id;
  final String title;
  final String content;
  final String date;
  final String adminId;
  final String adminName;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.adminId,
    required this.adminName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'adminId': adminId,
      'adminName': adminName,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      adminId: map['adminId'],
      adminName: map['adminName'],
    );
  }
}