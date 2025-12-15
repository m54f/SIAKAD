import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/teacher.dart';
import '../../providers/teacher_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class TeacherManagement extends StatefulWidget {
  const TeacherManagement({Key? key}) : super(key: key);

  @override
  State<TeacherManagement> createState() => _TeacherManagementState();
}

class _TeacherManagementState extends State<TeacherManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherProvider>(context, listen: false).fetchTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.teachers),
      ),
      body: Consumer<TeacherProvider>(
        builder: (context, teacherProvider, child) {
          if (teacherProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (teacherProvider.errorMessage != null) {
            return Center(
              child: Text(
                teacherProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => teacherProvider.fetchTeachers(),
            child: ListView.builder(
              itemCount: teacherProvider.teachers.length,
              itemBuilder: (context, index) {
                final teacher = teacherProvider.teachers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(teacher.name),
                    subtitle: Text(
                      'NIP: ${teacher.nip}\nMata Pelajaran: ${teacher.subject}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showTeacherForm(teacher),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirmed = await Helpers.showConfirmationDialog(
                              context,
                              'Hapus Guru',
                              'Apakah Anda yakin ingin menghapus data guru ini?',
                            );
                            
                            if (confirmed) {
                              await teacherProvider.deleteTeacher(teacher.id);
                              if (teacherProvider.errorMessage == null) {
                                Helpers.showSnackBar(
                                  context,
                                  'Data guru berhasil dihapus',
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
        onPressed: () => _showTeacherForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTeacherForm(Teacher? teacher) {
    final isEditing = teacher != null;
    final nipController = TextEditingController(text: teacher?.nip ?? '');
    final nameController = TextEditingController(text: teacher?.name ?? '');
    final subjectController = TextEditingController(text: teacher?.subject ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Guru' : 'Tambah Guru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nipController,
                decoration: const InputDecoration(
                  labelText: 'NIP',
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
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Mata Pelajaran',
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
              if (nipController.text.isEmpty ||
                  nameController.text.isEmpty ||
                  subjectController.text.isEmpty) {
                Helpers.showSnackBar(
                  context,
                  'Semua field harus diisi',
                  isError: true,
                );
                return;
              }

              final newTeacher = Teacher(
                id: isEditing ? teacher.id : Helpers.generateId(),
                nip: nipController.text,
                name: nameController.text,
                subject: subjectController.text,
              );

              if (isEditing) {
                await Provider.of<TeacherProvider>(context, listen: false)
                    .updateTeacher(newTeacher);
              } else {
                await Provider.of<TeacherProvider>(context, listen: false)
                    .addTeacher(newTeacher);
              }

              if (mounted) {
                Navigator.of(context).pop();
                
                final errorMessage = Provider.of<TeacherProvider>(
                  context,
                  listen: false,
                ).errorMessage;
                
                if (errorMessage == null) {
                  Helpers.showSnackBar(
                    context,
                    isEditing
                        ? 'Data guru berhasil diperbarui'
                        : 'Data guru berhasil ditambahkan',
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