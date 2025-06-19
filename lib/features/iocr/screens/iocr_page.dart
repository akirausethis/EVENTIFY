import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/shared/screens/list_page.dart';
import 'package:eventify_flutter/shared/widgets/choice_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IOCRPage extends StatelessWidget {
  const IOCRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What are you looking for?', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        color: AppTheme.primaryColor,
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ChoiceCard(
                title: "International Office",
                subtitle: "Credit Points",
                imagePath: "assets/images/Firefly.webp",
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ListPage(
                      pageTitle: 'International Office',
                      pageSubtitle: 'All on-going IO Events',
                      category: EventCategory.io, // <-- PERBAIKAN DI SINI
                    ),
                  ));
                },
              ),
              const SizedBox(height: 16),
              ChoiceCard(
                title: "Career Center",
                subtitle: "Credit Points",
                imagePath: "assets/images/Firefly.webp",
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ListPage(
                      pageTitle: 'Career Center',
                      pageSubtitle: 'All on-going CR Events',
                      category: EventCategory.cr, // <-- PERBAIKAN DI SINI
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}