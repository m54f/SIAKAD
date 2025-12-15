import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../../models/announcement.dart';
import '../../providers/announcement_provider.dart';
import '../../utils/constants.dart';

class AnnouncementView extends StatefulWidget {
  const AnnouncementView({Key? key}) : super(key: key);

  @override
  State<AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<AnnouncementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnnouncementProvider>(context, listen: false).fetchAnnouncements();
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

          final announcements = announcementProvider.announcements;

          if (announcements.isEmpty) {
            return const Center(child: Text('Tidak ada pengumuman.'));
          }

          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    announcement.title,
                    style: AppTextStyles.heading3,
                  ),
                  subtitle: Text('Tanggal: ${announcement.date}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        announcement.content,
                        style: AppTextStyles.body1,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}