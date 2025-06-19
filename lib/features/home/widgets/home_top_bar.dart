import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTopBar extends StatelessWidget {
  final String username;
  final VoidCallback onProfileClick;
  final VoidCallback onNotificationClick;

  const HomeTopBar({
    super.key,
    required this.username,
    required this.onProfileClick,
    required this.onNotificationClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onProfileClick,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/Firefly.webp'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome,", style: GoogleFonts.montserrat(fontSize: 14, color: AppTheme.secondaryTextColor)),
                    Text(username, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNotificationClick,
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.darkTextColor, size: 28),
          ),
        ],
      ),
    );
  }
}