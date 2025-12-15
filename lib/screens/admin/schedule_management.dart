import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/teacher_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class ScheduleManagement extends StatefulWidget {
  const ScheduleManagement({Key? key}) : super(key: key);

  @override
  State<ScheduleManagement> createState() => _ScheduleManagementState();
}

class _ScheduleManagementState extends State<ScheduleManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleProvider>(context, listen: false).fetchSchedules();
      Provider.of<TeacherProvider>(context, listen: false).fetchTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.schedule),
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, scheduleProvider, child) {
          if (scheduleProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (scheduleProvider.errorMessage != null) {
            return Center(
              child: Text(
                scheduleProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => scheduleProvider.fetchSchedules(),
            child: ListView.builder(
              itemCount: scheduleProvider.schedules.length,
              itemBuilder: (context, index) {
                final schedule = scheduleProvider.schedules[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(schedule.subject),
                    subtitle: Text(
                      'Hari: ${schedule.day}\n'
                      'Jam: ${schedule.time}\n'
                      'Guru: ${schedule.teacherName}\n'
                      'Kelas: ${schedule.className}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showScheduleForm(schedule),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirmed = await Helpers.showConfirmationDialog(
                              context,
                              'Hapus Jadwal',
                              'Apakah Anda yakin ingin menghapus jadwal ini?',
                            );
                            
                            if (confirmed) {
                              await scheduleProvider.deleteSchedule(schedule.id);
                              if (scheduleProvider.errorMessage == null) {
                                Helpers.showSnackBar(
                                  context,
                                  'Jadwal berhasil dihapus',
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
        onPressed: () => _showScheduleForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showScheduleForm(Schedule? schedule) {
    final isEditing = schedule != null;
    final dayController = TextEditingController(text: schedule?.day ?? '');
    final timeController = TextEditingController(text: schedule?.time ?? '');
    final subjectController = TextEditingController(text: schedule?.subject ?? '');
    final classNameController = TextEditingController(text: schedule?.className ?? '');
    
    String? selectedTeacherId = schedule?.teacherId;
    String? selectedTeacherName = schedule?.teacherName;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Jadwal' : 'Tambah Jadwal'),
        content: SingleChildScrollView(
          child: Consumer<TeacherProvider>(
            builder: (context, teacherProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: dayController.text.isEmpty ? null : dayController.text,
                    decoration: const InputDecoration(
                      labelText: 'Hari',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Senin', child: Text('Senin')),
                      DropdownMenuItem(value: 'Selasa', child: Text('Selasa')),
                      DropdownMenuItem(value: 'Rabu', child: Text('Rabu')),
                      DropdownMenuItem(value: 'Kamis', child: Text('Kamis')),
                      DropdownMenuItem(value: 'Jumat', child: Text('Jumat')),
                      DropdownMenuItem(value: 'Sabtu', child: Text('Sabtu')),
                    ],
                    onChanged: (value) {
                      dayController.text = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      labelText: 'Jam (contoh: 07:00-08:30)',
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedTeacherId,
                    decoration: const InputDecoration(
                      labelText: 'Guru',
                      border: OutlineInputBorder(),
                    ),
                    items: teacherProvider.teachers.map((teacher) {
                      return DropdownMenuItem<String>(
                        value: teacher.id,
                        child: Text(teacher.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedTeacherId = value;
                      if (value != null) {
                        final teacher = teacherProvider.teachers
                            .where((t) => t.id == value)
                            .first;
                        selectedTeacherName = teacher.name;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: classNameController,
                    decoration: const InputDecoration(
                      labelText: 'Kelas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (dayController.text.isEmpty ||
                  timeController.text.isEmpty ||
                  subjectController.text.isEmpty ||
                  selectedTeacherId == null ||
                  selectedTeacherName == null ||
                  classNameController.text.isEmpty) {
                Helpers.showSnackBar(
                  context,
                  'Semua field harus diisi',
                  isError: true,
                );
                return;
              }

              final newSchedule = Schedule(
                id: isEditing ? schedule.id : Helpers.generateId(),
                day: dayController.text,
                time: timeController.text,
                subject: subjectController.text,
                teacherId: selectedTeacherId!,
                teacherName: selectedTeacherName!,
                className: classNameController.text,
              );

              if (isEditing) {
                await Provider.of<ScheduleProvider>(context, listen: false)
                    .updateSchedule(newSchedule);
              } else {
                await Provider.of<ScheduleProvider>(context, listen: false)
                    .addSchedule(newSchedule);
              }

              if (mounted) {
                Navigator.of(context).pop();
                
                final errorMessage = Provider.of<ScheduleProvider>(
                  context,
                  listen: false,
                ).errorMessage;
                
                if (errorMessage == null) {
                  Helpers.showSnackBar(
                    context,
                    isEditing
                        ? 'Jadwal berhasil diperbarui'
                        : 'Jadwal berhasil ditambahkan',
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