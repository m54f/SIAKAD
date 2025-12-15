import 'package:flutter/material.dart';
import '../models/teacher.dart';
import '../services/database_service.dart';

class TeacherProvider with ChangeNotifier {
  List<Teacher> _teachers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Teacher> get teachers => _teachers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTeachers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _teachers = await DatabaseService().getAllTeachers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTeacher(Teacher teacher) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await DatabaseService().insertTeacher(teacher);
      await fetchTeachers();
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTeacher(Teacher teacher) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await DatabaseService().updateTeacher(teacher);
      await fetchTeachers();
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTeacher(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await DatabaseService().deleteTeacher(id);
      await fetchTeachers();
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}