import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor)),
          TextButton(
            onPressed: onSeeAll,
            child: Row(
              children: [
                const Icon(Icons.check_box, size: 20, color: AppTheme.darkTextColor),
                const SizedBox(width: 4),
                Text("See All", style: GoogleFonts.montserrat(color: AppTheme.darkTextColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}