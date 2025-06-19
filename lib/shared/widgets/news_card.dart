import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onClick;

  const NewsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFFFF7ED),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: AppTheme.darkTextColor,
                    borderRadius: BorderRadius.circular(16)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkTextColor)),
                    Text(subtitle,
                        style: GoogleFonts.montserrat(
                            fontSize: 14, color: AppTheme.secondaryTextColor)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: onClick,
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                      label: const Text("See More"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.darkTextColor,
                        elevation: 2,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        textStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}