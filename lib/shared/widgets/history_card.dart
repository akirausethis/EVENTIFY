import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryCard extends StatelessWidget {
  final String category;
  final String eventName;
  final String title;
  final String subtitle;
  final String status;

  const HistoryCard({
    super.key,
    required this.category,
    required this.eventName,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == 'Completed';
    final statusColor = isCompleted ? const Color(0xFF16A34A) : AppTheme.primaryColor;
    final statusIcon = isCompleted ? Icons.check_circle : Icons.hourglass_empty;

    return Column(
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
              child: const Icon(Icons.article_outlined, color: AppTheme.primaryColor, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.montserrat(color: AppTheme.secondaryTextColor, fontSize: 14),
                ),
                Text(
                  eventName,
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: AppTheme.primaryColor.withOpacity(0.95),
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: AppTheme.darkTextColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Firefly.webp'),
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: GoogleFonts.montserrat(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}