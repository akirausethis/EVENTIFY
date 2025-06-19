import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/features/create/screens/create_cr_page.dart';
import 'package:eventify_flutter/features/create/screens/create_io_page.dart';
import 'package:eventify_flutter/features/create/screens/create_news_page.dart';
import 'package:eventify_flutter/features/create/screens/create_oprec_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateChoicePage extends StatelessWidget {
  const CreateChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: ClipPath(
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
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Create New Post",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _ChoiceTile(
            icon: Icons.campaign_outlined,
            title: "Open Recruitment",
            subtitle: "Post a new oprec for your organization.",
            onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateOprecPage())),
          ),
          _ChoiceTile(
            icon: Icons.public_outlined,
            title: "International Office",
            subtitle: "Share a new IO opportunity or event.",
            onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateIoPage())),
          ),
          _ChoiceTile(
            icon: Icons.work_outline_outlined,
            title: "Career Center",
            subtitle: "Post a new job or career event.",
            onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateCrPage())),
          ),
          _ChoiceTile(
            icon: Icons.newspaper_outlined,
            title: "News",
            subtitle: "Publish a new article or announcement.",
            onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateNewsPage())),
          ),
        ],
      ),
    );
  }
}

// Widget private untuk setiap tile pilihan
class _ChoiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onClick;

  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: AppTheme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor)
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.montserrat(fontSize: 14, color: AppTheme.secondaryTextColor),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppTheme.secondaryTextColor),
            ],
          ),
        ),
      ),
    );
  }
}

// Clipper untuk AppBar melengkung
class _CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}