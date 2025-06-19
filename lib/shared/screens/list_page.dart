import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/services/firestore_service.dart';
import 'package:eventify_flutter/shared/screens/detail_page.dart';
import 'package:eventify_flutter/shared/widgets/event_list_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPage extends StatefulWidget {
  final String pageTitle;
  final String pageSubtitle;
  final EventCategory category;

  const ListPage({
    super.key,
    required this.pageTitle,
    required this.pageSubtitle,
    required this.category,
  });

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<EventModel> _allItems = [];
  List<EventModel> _foundItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });
    // Mengambil data dari Firestore service berdasarkan kategori
    final events = await _firestoreService.getEvents(widget.category);
    setState(() {
      _allItems = events;
      _foundItems = _allItems;
      _isLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<EventModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allItems;
    } else {
      results = _allItems
          .where((item) =>
              item.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: _CurvedAppBar(title: widget.pageTitle, subtitle: widget.pageSubtitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                prefixIcon: const Icon(Icons.search, color: AppTheme.secondaryTextColor),
                filled: true,
                fillColor: AppTheme.inputFieldColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _foundItems.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          itemCount: _foundItems.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = _foundItems[index];
                            return EventListCard(
                              title: item.title,
                              subtitle: item.subtitle,
                              onClick: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailPage(event: item),
                                ));
                              },
                            );
                          },
                        )
                      : const Center(child: Text('No events found.', style: TextStyle(fontSize: 18))),
            ),
          ],
        ),
      ),
    );
  }
}

// ... (Widget _CurvedAppBar dan _CurvedAppBarClipper tetap sama)
class _CurvedAppBar extends StatelessWidget {
  const _CurvedAppBar({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CurvedAppBarClipper(),
      child: Container(
        color: AppTheme.primaryColor,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              Positioned(
                top: 4, left: 4,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  label: Text("Back", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: GoogleFonts.montserrat(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}