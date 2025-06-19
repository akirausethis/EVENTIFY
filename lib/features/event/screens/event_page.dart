import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/features/event/screens/event_list_page.dart';
import 'package:eventify_flutter/shared/widgets/major_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    // -- Data 12 jurusan --
    final majors = [
      "IMT", "ISB", "FIKOM", "IBM", "CB", "ACC", 
      "PSY", "MED", "FDB", "FTP", "LAW", "ARCH"
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: ClipPath(
          clipper: CurvedAppBarClipper(),
          child: Container(
            color: AppTheme.primaryColor,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 16,
                  right: 16,
                  bottom: 30), // Padding bawah agar tidak mepet lengkungan
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // -- DIBUAT MENJADI TENGAH --
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  Text(
                    "See All Available Events",
                    textAlign: TextAlign.center, // Perataan teks
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "All Across the Majors",
                    textAlign: TextAlign.center, // Perataan teks
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        // -- Menampilkan semua 12 jurusan --
        itemCount: majors.length,
        itemBuilder: (context, index) {
          final major = majors[index];
          return MajorCard(
            majorName: major,
            onClick: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventListPage(majorName: major),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Class clipper tetap sama
class CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}