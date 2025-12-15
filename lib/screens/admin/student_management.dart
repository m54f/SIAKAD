import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../../providers/student_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({Key? key}) : super(key: key);

  @override
  State<StudentManagement> createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false).fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.students),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, studentProvider, child) {
          if (studentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (studentProvider.errorMessage != null) {
            return Center(
              child: Text(
                studentProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => studentProvider.fetchStudents(),
            child: ListView.builder(
              itemCount: studentProvider.students.length,
              itemBuilder: (context, index) {
                final student = studentProvider.students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(student.name),
                    subtitle: Text(
                      'NIS: ${student.nis}\nKelas: ${student.className} - ${student.major}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showStudentForm(student),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirmed = await Helpers.showConfirmationDialog(
                              context,
                              'Hapus Siswa',
                              'Apakah Anda yakin ingin menghapus data siswa ini?',
                            );
                            
                            if (confirmed) {
                              await studentProvider.deleteStudent(student.id);
                              if (studentProvider.errorMessage == null) {
                                Helpers.showSnackBar(
                                  context,
                                  'Data siswa berhasil dihapus',
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStudentForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showStudentForm(Student? student) {
    final isEditing = student != null;
    final nisController = TextEditingController(text: student?.nis ?? '');
    final nameController = TextEditingController(text: student?.name ?? '');
    final classNameController = TextEditingController(text: student?.className ?? '');
    final majorController = TextEditingController(text: student?.major ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Siswa' : 'Tambah Siswa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nisController,
                decoration: const InputDecoration(
                  labelText: 'NIS',
                  border: OutlineInputBorder(),
                ),
                enabled: !isEditing,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: classNameController,
                decoration: const InputDecoration(
                  labelText: 'Kelas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: majorController,
                decoration: const InputDecoration(
                  labelText: 'Jurusan',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nisController.text.isEmpty ||
                  nameController.text.isEmpty ||
                  classNameController.text.isEmpty ||
                  majorController.text.isEmpty) {
                Helpers.showSnackBar(
                  context,
                  'Semua field harus diisi',
                  isError: true,
                );
                return;
              }

              final newStudent = Student(
                id: isEditing ? student.id : Helpers.generateId(),
                nis: nisController.text,
                name: nameController.text,
                className: classNameController.text,
                major: majorController.text,
              );

              if (isEditing) {
                await Provider.of<StudentProvider>(context, listen: false)
                    .updateStudent(newStudent);
              } else {
                await Provider.of<StudentProvider>(context, listen: false)
                    .addStudent(newStudent);
              }

              if (mounted) {
                Navigator.of(context).pop();
                
                final errorMessage = Provider.of<StudentProvider>(
                  context,
                  listen: false,
                ).errorMessage;
                
                if (errorMessage == null) {
                  Helpers.showSnackBar(
                    context,
                    isEditing
                        ? 'Data siswa berhasil diperbarui'
                        : 'Data siswa berhasil ditambahkan',
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}