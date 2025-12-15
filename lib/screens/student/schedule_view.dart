import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../utils/constants.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  String? _studentClassName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ambil data siswa untuk mengetahui kelasnya
      final studentId = Provider.of<AuthProvider>(context, listen: false).user!.id;
      Provider.of<StudentProvider>(context, listen: false).getStudentById(studentId).then((student) {
        if (student != null) {
          setState(() {
            _studentClassName = student.className;
          });
          // Setelah kelas diketahui, ambil jadwal berdasarkan kelas
          Provider.of<ScheduleProvider>(context, listen: false).fetchSchedulesByClass(student.className);
        }
      });
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

          if (_studentClassName == null) {
            return const Center(child: Text('Data kelas tidak ditemukan.'));
          }

          final schedules = scheduleProvider.schedules;

          if (schedules.isEmpty) {
            return Center(child: Text('Belum ada jadwal untuk kelas $_studentClassName'));
          }

          // Kelompokkan jadwal berdasarkan hari
          final Map<String, List<Schedule>> groupedSchedules = {};
          for (var schedule in schedules) {
            if (!groupedSchedules.containsKey(schedule.day)) {
              groupedSchedules[schedule.day] = [];
            }
            groupedSchedules[schedule.day]!.add(schedule);
          }

          return ListView(
            children: groupedSchedules.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                    entry.key,
                    style: AppTextStyles.heading2,
                  ),
                  children: entry.value.map((schedule) {
                    return ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(schedule.subject),
                      subtitle: Text('${schedule.time} - ${schedule.teacherName}'),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}