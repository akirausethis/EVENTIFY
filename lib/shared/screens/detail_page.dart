import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final EventModel event;

  const DetailPage({
    super.key,
    required this.event,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _firestoreService.addEventToHistory(widget.event);
  }

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
    final event = widget.event;
    final List<Widget> detailSections = [];
    bool showRegisterButton = true;
    final categoryTitle = _getCategoryTitle(event.category);

    switch (event.category) {
      case EventCategory.oprec:
      case EventCategory.io:
      case EventCategory.cr:
        if (event.detailsContent.isNotEmpty) detailSections.add(_DetailInfoSection(icon: Icons.description_outlined, category: categoryTitle, title: 'Event Details', content: event.detailsContent));
        if (event.registrationDate != null && event.registrationDate!.isNotEmpty) detailSections.add(_DetailInfoSection(icon: Icons.calendar_today_outlined, category: categoryTitle, title: 'Registration Date', content: event.registrationDate!));
        if (event.benefits != null && event.benefits!.isNotEmpty) detailSections.add(_DetailInfoSection(icon: Icons.star_border_outlined, category: categoryTitle, title: 'Benefits', content: event.benefits!));
        if (event.category == EventCategory.oprec && event.conditions != null && event.conditions!.isNotEmpty) {
           detailSections.add(_DetailInfoSection(icon: Icons.verified_user_outlined, category: categoryTitle, title: 'Conditions', content: event.conditions!));
        }
        if (event.dDayDate != null && event.dDayDate!.isNotEmpty) detailSections.add(_DetailInfoSection(icon: Icons.flag_outlined, category: categoryTitle, title: 'D-Day Date', content: event.dDayDate!));
        break;
      case EventCategory.news:
        if (event.detailsContent.isNotEmpty) detailSections.add(_DetailInfoSection(icon: Icons.info_outline, category: 'News', title: 'News Details', content: event.detailsContent));
        showRegisterButton = false;
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            backgroundColor: AppTheme.primaryColor,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.title,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              background: Image.asset(
                event.imagePath,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.4),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                // --- PERUBAHAN: JUDUL DIBUAT RATA TENGAH ---
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text(
                    event.title,
                    textAlign: TextAlign.center, // Rata tengah
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkTextColor
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.subtitle,
                    textAlign: TextAlign.center, // Rata tengah
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                  const Divider(height: 40, thickness: 1),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: detailSections[index],
                );
              },
              childCount: detailSections.length,
            ),
          ),
          if (showRegisterButton)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)
                  ),
                  onPressed: () {},
                  child: const Text("REGISTER NOW")
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailInfoSection extends StatelessWidget {
  final IconData icon;
  final String category;
  final String title;
  final String content;

  const _DetailInfoSection({
    required this.icon,
    required this.category,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // --- PERUBAHAN: Latar Belakang Oranye ---
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.08), // Warna oranye lembut
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white, // Latar ikon dibuat putih
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 10
                    )
                  ]
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.montserrat(
                      color: AppTheme.secondaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkTextColor
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              content,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                color: AppTheme.darkTextColor.withOpacity(0.9),
                height: 1.6
              ),
            ),
          ),
        ],
      ),
    );
  }
}