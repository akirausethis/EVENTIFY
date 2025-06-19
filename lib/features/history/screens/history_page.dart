import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/services/firestore_service.dart';
import 'package:eventify_flutter/shared/screens/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<EventModel>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = _firestoreService.getViewHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Column(
          children: [
            Text(
              "History",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "Here are all the events that you've viewed",
              style: GoogleFonts.montserrat(
                  fontSize: 12, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadHistory();
        },
        child: FutureBuilder<List<EventModel>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Your viewing history is empty.\nView an event to see it here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final historyItems = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 90),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return _HistoryItemCard(event: item);
              },
            );
          },
        ),
      ),
    );
  }
}

// WIDGET KARTU DIKEMBALIKAN KE DESAIN AWAL YANG ANDA SUKA
class _HistoryItemCard extends StatelessWidget {
  final EventModel event;
  const _HistoryItemCard({required this.event});

  String _getCategoryTitle(EventCategory category) {
    switch (category) {
      case EventCategory.oprec:
        return 'Open Recruitment';
      case EventCategory.io:
        return 'International Office';
      case EventCategory.cr:
        return 'Career Center';
      case EventCategory.news:
        return 'News';
      default:
        return 'Event';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (context) => DetailPage(event: event),
            ))
            .then((_) =>
                (context as Element).reassemble()); // Refresh saat kembali
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.article_outlined,
                    color: AppTheme.primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getCategoryTitle(event.category),
                    style: GoogleFonts.montserrat(
                        color: AppTheme.secondaryTextColor, fontSize: 14),
                  ),
                  Text(
                    "Event Name", // Placeholder sesuai desain
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkTextColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: AppTheme.primaryColor,
            elevation: 4,
            shadowColor: AppTheme.primaryColor.withOpacity(0.3),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Placeholder untuk gambar logo/jurusan
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.darkTextColor,
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Firefly.webp'),
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.subtitle,
                          style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24), // Memberi jarak antar kartu
        ],
      ),
    );
  }
}