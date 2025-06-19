import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum untuk menentukan tipe dialog
enum DialogType { success, confirmation }

// Fungsi untuk menampilkan dialog
Future<bool?> showCustomNotificationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required DialogType type,
  String confirmButtonText = "OK",
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // User harus menekan tombol
    builder: (BuildContext context) {
      // Menentukan ikon dan warna berdasarkan tipe
      IconData iconData;
      Color iconColor;
      if (type == DialogType.success) {
        iconData = Icons.check_circle_outline;
        iconColor = Colors.green;
      } else {
        iconData = Icons.help_outline;
        iconColor = Colors.amber.shade800;
      }

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(iconData, color: iconColor),
            const SizedBox(width: 10),
            Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.montserrat(height: 1.5, color: AppTheme.secondaryTextColor),
        ),
        // --- PERBAIKAN UI TOMBOL DI SINI ---
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        actions: <Widget>[
          if (type == DialogType.confirmation)
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryTextColor
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // Menambahkan sedikit padding horizontal pada tombol
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              )
            ),
            child: Text(
              confirmButtonText,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
