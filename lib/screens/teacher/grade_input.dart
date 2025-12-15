import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/grade.dart';
//import '../../models/student.dart';
import '../../providers/grade_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/auth_provider.dart';
//import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class GradeInputScreen extends StatefulWidget {
  const GradeInputScreen({Key? key}) : super(key: key);

  @override
  State<GradeInputScreen> createState() => _GradeInputScreenState();
}

class _GradeInputScreenState extends State<GradeInputScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStudentId;
  String? _selectedStudentName;
  final _subjectController = TextEditingController();
  final _assignmentController = TextEditingController();
  final _midTermController = TextEditingController();
  final _finalExamController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false).fetchStudents();
    });
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _assignmentController.dispose();
    _midTermController.dispose();
    _finalExamController.dispose();
    super.dispose();
  }

  void _calculateAndSaveGrade() {
    if (!_formKey.currentState!.validate() || _selectedStudentId == null) {
      Helpers.showSnackBar(context, 'Harap pilih siswa dan isi semua nilai', isError: true);
      return;
    }

    final assignment = int.parse(_assignmentController.text);
    final midTerm = int.parse(_midTermController.text);
    final finalExam = int.parse(_finalExamController.text);

    final finalScore = Grade.calculateFinalScore(assignment, midTerm, finalExam);
    final predicate = Grade.calculatePredicate(finalScore);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final newGrade = Grade(
      id: Helpers.generateId(),
      studentId: _selectedStudentId!,
      studentName: _selectedStudentName!,
      subject: _subjectController.text,
      teacherId: authProvider.user!.id,
      teacherName: authProvider.user!.name,
      assignment: assignment,
      midTerm: midTerm,
      finalExam: finalExam,
      finalScore: finalScore,
      predicate: predicate,
      semester: Helpers.getCurrentSemester(),
      academicYear: Helpers.getCurrentAcademicYear(),
    );

    Provider.of<GradeProvider>(context, listen: false).addGrade(newGrade).then((_) {
      if (mounted) {
        Navigator.of(context).pop();
        _formKey.currentState?.reset();
        _selectedStudentId = null;
        Helpers.showSnackBar(context, 'Nilai berhasil disimpan!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Nilai Siswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<StudentProvider>(
                  builder: (context, studentProvider, child) {
                    if (studentProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return DropdownButtonFormField<String>(
                      hint: const Text('Pilih Siswa'),
                      value: _selectedStudentId,
                      items: studentProvider.students.map((student) {
                        return DropdownMenuItem<String>(
                          value: student.id,
                          child: Text('${student.name} (${student.nis})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStudentId = value;
                          final selectedStudent = studentProvider.students.firstWhere((s) => s.id == value);
                          _selectedStudentName = selectedStudent.name;
                        });
                      },
                      validator: (value) => value == null ? 'Siswa harus dipilih' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Mata Pelajaran',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Mata pelajaran harus diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _assignmentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nilai Tugas (30%)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nilai tugas harus diisi';
                    final val = int.tryParse(value);
                    if (val == null || val < 0 || val > 100) return 'Masukkan angka 0-100';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _midTermController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nilai UTS (30%)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nilai UTS harus diisi';
                    final val = int.tryParse(value);
                    if (val == null || val < 0 || val > 100) return 'Masukkan angka 0-100';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _finalExamController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nilai UAS (40%)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nilai UAS harus diisi';
                    final val = int.tryParse(value);
                    if (val == null || val < 0 || val > 100) return 'Masukkan angka 0-100';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Consumer<GradeProvider>(
                  builder: (context, gradeProvider, child) {
                    if (gradeProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: _calculateAndSaveGrade,
                      child: const Text('Simpan Nilai'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}