import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/features/auth/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacer untuk mendorong konten ke tengah secara vertikal
              const Spacer(),

              // Ilustrasi
              Image.asset(
                'assets/images/People3.jpg',
                height: 280, // Ukuran disesuaikan agar lebih proporsional
              ),
              const SizedBox(height: 40),

              // Judul Utama
              Text(
                "Discover & Join Events Effortlessly",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 28, // Ukuran font diperbesar
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkTextColor,
                  height: 1.2, // Jarak antar baris
                ),
              ),
              const SizedBox(height: 16),

              // Sub-judul atau Tagline
              Text(
                "Find all campus activities, from open recruitments to international programs, all in one place.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: AppTheme.secondaryTextColor,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // Tombol Utama
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18), // Tombol lebih tinggi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Sudut lebih rounded
                    ),
                  ),
                  onPressed: () {
                    // Arahkan ke LoginPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Text(
                    "GET STARTED",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}