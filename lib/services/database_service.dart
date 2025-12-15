import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/schedule.dart';
import '../models/grade.dart';
import '../models/announcement.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'academic_system.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        role INTEGER NOT NULL
      )
    ''');

    // Create students table
    await db.execute('''
      CREATE TABLE students (
        id TEXT PRIMARY KEY,
        nis TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        className TEXT NOT NULL,
        major TEXT NOT NULL
      )
    ''');

    // Create teachers table
    await db.execute('''
      CREATE TABLE teachers (
        id TEXT PRIMARY KEY,
        nip TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        subject TEXT NOT NULL
      )
    ''');

    // Create schedules table
    await db.execute('''
      CREATE TABLE schedules (
        id TEXT PRIMARY KEY,
        day TEXT NOT NULL,
        time TEXT NOT NULL,
        subject TEXT NOT NULL,
        teacherId TEXT NOT NULL,
        teacherName TEXT NOT NULL,
        className TEXT NOT NULL
      )
    ''');

    // Create grades table
    await db.execute('''
      CREATE TABLE grades (
        id TEXT PRIMARY KEY,
        studentId TEXT NOT NULL,
        studentName TEXT NOT NULL,
        subject TEXT NOT NULL,
        teacherId TEXT NOT NULL,
        teacherName TEXT NOT NULL,
        assignment INTEGER NOT NULL,
        midTerm INTEGER NOT NULL,
        finalExam INTEGER NOT NULL,
        finalScore INTEGER NOT NULL,
        predicate TEXT NOT NULL,
        semester TEXT NOT NULL,
        academicYear TEXT NOT NULL
      )
    ''');

    // Create announcements table
    await db.execute('''
      CREATE TABLE announcements (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        adminId TEXT NOT NULL,
        adminName TEXT NOT NULL
      )
    ''');

    // Insert default admin user
    await db.insert('users', User(
      id: 'admin-1',
      username: 'admin',
      password: 'admin123',
      name: 'Administrator',
      role: UserRole.admin,
    ).toMap());

    // Insert sample teacher
    await db.insert('users', User(
      id: 'teacher-1',
      username: 'guru1',
      password: 'guru123',
      name: 'Budi Santoso',
      role: UserRole.teacher,
    ).toMap());

    await db.insert('teachers', Teacher(
      id: 'teacher-1',
      nip: '198001012022031001',
      name: 'Budi Santoso',
      subject: 'Matematika',
    ).toMap());

    // Insert sample student
    await db.insert('users', User(
      id: 'student-1',
      username: 'siswa1',
      password: 'siswa123',
      name: 'Ahmad Rizki',
      role: UserRole.student,
    ).toMap());

    await db.insert('students', Student(
      id: 'student-1',
      nis: '20230001',
      name: 'Ahmad Rizki',
      className: 'XII IPA 1',
      major: 'IPA',
    ).toMap());
  }

  // User operations
  Future<User?> getUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Student operations
  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<Student?> getStudentById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Student.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertStudent(Student student) async {
    final db = await database;
    await db.insert('students', student.toMap());
  }

  Future<void> updateStudent(Student student) async {
    final db = await database;
    await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<void> deleteStudent(String id) async {
    final db = await database;
    await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Teacher operations
  Future<List<Teacher>> getAllTeachers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('teachers');
    return List.generate(maps.length, (i) {
      return Teacher.fromMap(maps[i]);
    });
  }

  Future<Teacher?> getTeacherById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'teachers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Teacher.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertTeacher(Teacher teacher) async {
    final db = await database;
    await db.insert('teachers', teacher.toMap());
  }

  Future<void> updateTeacher(Teacher teacher) async {
    final db = await database;
    await db.update(
      'teachers',
      teacher.toMap(),
      where: 'id = ?',
      whereArgs: [teacher.id],
    );
  }

  Future<void> deleteTeacher(String id) async {
    final db = await database;
    await db.delete(
      'teachers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Schedule operations
  Future<List<Schedule>> getAllSchedules() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('schedules');
    return List.generate(maps.length, (i) {
      return Schedule.fromMap(maps[i]);
    });
  }

  Future<List<Schedule>> getSchedulesByClass(String className) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'schedules',
      where: 'className = ?',
      whereArgs: [className],
    );
    return List.generate(maps.length, (i) {
      return Schedule.fromMap(maps[i]);
    });
  }

  Future<void> insertSchedule(Schedule schedule) async {
    final db = await database;
    await db.insert('schedules', schedule.toMap());
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final db = await database;
    await db.update(
      'schedules',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<void> deleteSchedule(String id) async {
    final db = await database;
    await db.delete(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Grade operations
  Future<List<Grade>> getAllGrades() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('grades');
    return List.generate(maps.length, (i) {
      return Grade.fromMap(maps[i]);
    });
  }

  Future<List<Grade>> getGradesByStudent(String studentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'grades',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
    return List.generate(maps.length, (i) {
      return Grade.fromMap(maps[i]);
    });
  }

  Future<List<Grade>> getGradesByTeacher(String teacherId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'grades',
      where: 'teacherId = ?',
      whereArgs: [teacherId],
    );
    return List.generate(maps.length, (i) {
      return Grade.fromMap(maps[i]);
    });
  }

  Future<void> insertGrade(Grade grade) async {
    final db = await database;
    await db.insert('grades', grade.toMap());
  }

  Future<void> updateGrade(Grade grade) async {
    final db = await database;
    await db.update(
      'grades',
      grade.toMap(),
      where: 'id = ?',
      whereArgs: [grade.id],
    );
  }

  Future<void> deleteGrade(String id) async {
    final db = await database;
    await db.delete(
      'grades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Announcement operations
  Future<List<Announcement>> getAllAnnouncements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'announcements',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return Announcement.fromMap(maps[i]);
    });
  }

  Future<void> insertAnnouncement(Announcement announcement) async {
    final db = await database;
    await db.insert('announcements', announcement.toMap());
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    final db = await database;
    await db.update(
      'announcements',
      announcement.toMap(),
      where: 'id = ?',
      whereArgs: [announcement.id],
    );
  }

  Future<void> deleteAnnouncement(String id) async {
    final db = await database;
    await db.delete(
      'announcements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}