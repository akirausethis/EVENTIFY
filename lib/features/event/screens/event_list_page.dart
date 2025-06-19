import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/services/firestore_service.dart';
import 'package:eventify_flutter/shared/screens/detail_page.dart';
import 'package:eventify_flutter/shared/widgets/event_list_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventListPage extends StatefulWidget {
  final String majorName;

  const EventListPage({
    super.key,
    required this.majorName,
  });

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    // Mengambil data dari Firestore berdasarkan jurusan
    _eventsFuture = _firestoreService.getOprecByMajor(widget.majorName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: _CurvedAppBar(majorName: widget.majorName),
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found for this major.'));
          }
          final eventItems = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: eventItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = eventItems[index];
              return EventListCard(
                title: item.title,
                subtitle: item.subtitle,
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailPage(event: item),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Widget private untuk AppBar
class _CurvedAppBar extends StatelessWidget {
  const _CurvedAppBar({required this.majorName});
  final String majorName;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CurvedAppBarClipper(),
      child: Container(
        color: AppTheme.primaryColor,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: 4,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  label: Text("Back", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Here are the List of", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("All On-going $majorName Events", style: GoogleFonts.montserrat(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}