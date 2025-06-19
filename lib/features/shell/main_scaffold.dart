import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/features/create/screens/create_choice_page.dart';
import 'package:eventify_flutter/features/event/screens/event_page.dart';
import 'package:eventify_flutter/features/history/screens/history_page.dart';
import 'package:eventify_flutter/features/home/screens/home_page.dart';
import 'package:eventify_flutter/features/iocr/screens/iocr_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang akan ditampilkan di dalam PageView
    final pages = <Widget>[
      const HomePage(),
      const EventPage(),
      const IOCRPage(),
      const HistoryPage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
            _buildNavItem(icon: Icons.campaign, label: 'Event', index: 1),
            const SizedBox(width: 48), // Ruang untuk FAB
            _buildNavItem(icon: Icons.menu_book, label: 'IO/CR', index: 2),
            _buildNavItem(icon: Icons.list_alt, label: 'History', index: 3),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // --- PERBAIKAN DI SINI ---
          // Navigasi ke halaman CreateChoicePage saat tombol + ditekan
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateChoicePage(),
            ),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: AppTheme.primaryColor,
        elevation: 4.0,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  // Widget untuk setiap item navigasi
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppTheme.primaryColor : AppTheme.secondaryTextColor;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}