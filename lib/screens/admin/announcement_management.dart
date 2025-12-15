import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/announcement.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class AnnouncementManagement extends StatefulWidget {
  const AnnouncementManagement({Key? key}) : super(key: key);

  @override
  State<AnnouncementManagement> createState() => _AnnouncementManagementState();
}

class _AnnouncementManagementState extends State<AnnouncementManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.announcements),
      ),
      body: Consumer<AnnouncementProvider>(
        builder: (context, announcementProvider, child) {
          if (announcementProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (announcementProvider.errorMessage != null) {
            return Center(
              child: Text(
                announcementProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => announcementProvider.fetchAnnouncements(),
            child: ListView.builder(
              itemCount: announcementProvider.announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcementProvider.announcements[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(announcement.title),
                    subtitle: Text(
                      'Tanggal: ${announcement.date}\n'
                      'Admin: ${announcement.adminName}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showAnnouncementForm(announcement),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirmed = await Helpers.showConfirmationDialog(
                              context,
                              'Hapus Pengumuman',
                              'Apakah Anda yakin ingin menghapus pengumuman ini?',
                            );
                            
                            if (confirmed) {
                              await announcementProvider
                                  .deleteAnnouncement(announcement.id);
                              if (announcementProvider.errorMessage == null) {
                                Helpers.showSnackBar(
                                  context,
                                  'Pengumuman berhasil dihapus',
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
        onPressed: () => _showAnnouncementForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAnnouncementForm(Announcement? announcement) {
    final isEditing = announcement != null;
    final titleController = TextEditingController(text: announcement?.title ?? '');
    final contentController = TextEditingController(text: announcement?.content ?? '');
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final adminId = authProvider.user!.id;
    final adminName = authProvider.user!.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Pengumuman' : 'Tambah Pengumuman'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
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
              if (titleController.text.isEmpty || contentController.text.isEmpty) {
                Helpers.showSnackBar(
                  context,
                  'Judul dan isi harus diisi',
                  isError: true,
                );
                return;
              }

              final newAnnouncement = Announcement(
                id: isEditing ? announcement.id : Helpers.generateId(),
                title: titleController.text,
                content: contentController.text,
                date: isEditing
                    ? announcement.date
                    : Helpers.formatDate(DateTime.now()),
                adminId: adminId,
                adminName: adminName,
              );

              if (isEditing) {
                await Provider.of<AnnouncementProvider>(context, listen: false)
                    .updateAnnouncement(newAnnouncement);
              } else {
                await Provider.of<AnnouncementProvider>(context, listen: false)
                    .addAnnouncement(newAnnouncement);
              }

              if (mounted) {
                Navigator.of(context).pop();
                
                final errorMessage = Provider.of<AnnouncementProvider>(
                  context,
                  listen: false,
                ).errorMessage;
                
                if (errorMessage == null) {
                  Helpers.showSnackBar(
                    context,
                    isEditing
                        ? 'Pengumuman berhasil diperbarui'
                        : 'Pengumuman berhasil ditambahkan',
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