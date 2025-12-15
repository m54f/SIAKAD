import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../../models/grade.dart';
import '../../models/student.dart';
import '../../providers/grade_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../services/pdf_service.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class GradeView extends StatefulWidget {
  const GradeView({Key? key}) : super(key: key);

  @override
  State<GradeView> createState() => _GradeViewState();
}

class _GradeViewState extends State<GradeView> {
  Student? _currentStudent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentId = Provider.of<AuthProvider>(context, listen: false).user!.id;
      Provider.of<StudentProvider>(context, listen: false).getStudentById(studentId).then((student) {
        if (student != null) {
          setState(() {
            _currentStudent = student;
          });
          Provider.of<GradeProvider>(context, listen: false).fetchGradesByStudent(student.id);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.reportCard),
        actions: [
          if (_currentStudent != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Ekspor ke PDF',
              onPressed: () {
                final grades = Provider.of<GradeProvider>(context, listen: false).grades;
                if (grades.isNotEmpty) {
                  PdfService.generateReportCard(
                    _currentStudent!,
                    grades,
                    Helpers.getCurrentSemester(),
                    Helpers.getCurrentAcademicYear(),
                  );
                } else {
                  Helpers.showSnackBar(context, 'Tidak ada nilai untuk diekspor', isError: true);
                }
              },
            ),
        ],
      ),
      body: Consumer<GradeProvider>(
        builder: (context, gradeProvider, child) {
          if (gradeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (gradeProvider.errorMessage != null) {
            return Center(
              child: Text(
                gradeProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final grades = gradeProvider.grades;

          if (grades.isEmpty) {
            return const Center(child: Text('Belum ada nilai yang dimasukkan.'));
          }

          return DataTable(
            columns: const [
              DataColumn(label: Text('Mata Pelajaran')),
              DataColumn(label: Text('Tugas')),
              DataColumn(label: Text('UTS')),
              DataColumn(label: Text('UAS')),
              DataColumn(label: Text('Nilai Akhir')),
              DataColumn(label: Text('Predikat')),
            ],
            rows: grades.map((grade) {
              Color predicateColor = Colors.black;
              switch (grade.predicate) {
                case 'A':
                  predicateColor = Colors.green;
                  break;
                case 'B':
                  predicateColor = Colors.blue;
                  break;
                case 'C':
                  predicateColor = Colors.orange;
                  break;
                case 'D':
                  predicateColor = Colors.red;
                  break;
              }

              return DataRow(
                cells: [
                  DataCell(Text(grade.subject)),
                  DataCell(Text('${grade.assignment}')),
                  DataCell(Text('${grade.midTerm}')),
                  DataCell(Text('${grade.finalExam}')),
                  DataCell(Text('${grade.finalScore}')),
                  DataCell(
                    Text(
                      grade.predicate,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: predicateColor,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}