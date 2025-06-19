import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/features/auth/screens/landing_page.dart';
import 'package:eventify_flutter/services/firestore_service.dart';
import 'package:eventify_flutter/shared/screens/detail_page.dart';
import 'package:eventify_flutter/shared/screens/list_page.dart';
import 'package:eventify_flutter/shared/widgets/custom_notification_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<EventModel>> _oprecEventsFuture;
  late Future<List<EventModel>> _newsEventsFuture;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    _oprecEventsFuture = _firestoreService.getAllOprecEvents();
    _newsEventsFuture = _firestoreService.getAllNewsEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadEvents();
          });
        },
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 90),
          children: [
            _HomeTopBar(onProfileClick: () {}),
            const SizedBox(height: 16),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: _QuotesCard()),
            _SectionHeader(
              title: "Open Recruitment",
              onSeeAll: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListPage(
                  pageTitle: 'Open Recruitment',
                  pageSubtitle: 'All available oprec events',
                  category: EventCategory.oprec,
                ),
              )),
            ),
            SizedBox(
              height: 255,
              child: FutureBuilder<List<EventModel>>(
                future: _oprecEventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No recruitment events found.'));
                  }
                  final recruitments = snapshot.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: recruitments.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final item = recruitments[index];
                      return _RecruitmentItemCard(
                        title: item.title,
                        subtitle: item.subtitle,
                        imagePath: item.imagePath,
                        onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(event: item))),
                      );
                    },
                  );
                },
              ),
            ),
            _SectionHeader(
              title: "News",
              onSeeAll: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListPage(
                  pageTitle: 'News',
                  pageSubtitle: 'Latest news and updates',
                  category: EventCategory.news,
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<EventModel>>(
                future: _newsEventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No news found.'));
                  }
                  final news = snapshot.data!;
                  return Column(
                    children: news.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _NewsItemCard(
                        title: item.title,
                        subtitle: item.subtitle,
                        onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(event: item))),
                      ),
                    )).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTopBar extends StatefulWidget {
  final VoidCallback onProfileClick;
  const _HomeTopBar({required this.onProfileClick});

  @override
  State<_HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<_HomeTopBar> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _username = 'Guest';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          _username = doc.data()?['username'] ?? 'User';
        });
      }
    }
  }

Future<void> _signOut() async {
  // --- NOTIFIKASI BARU ---
  final confirmed = await showCustomNotificationDialog(
    context: context,
    title: "Confirm Logout",
    message: "Are you sure you want to sign out?",
    type: DialogType.confirmation,
    confirmButtonText: "Confirm",
  );

  // Jika pengguna menekan "Confirm", maka `confirmed` akan bernilai true
  if (confirmed == true) {
    await _auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LandingPage()),
        (route) => false,
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: widget.onProfileClick,
                child: const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/Firefly.webp'),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome,", style: GoogleFonts.montserrat(fontSize: 14, color: AppTheme.secondaryTextColor)),
                  Text(_username, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor)),
                ],
              ),
            ],
          ),
          // Tambahkan PopupMenuButton untuk Logout
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _signOut();
              }
            },
            icon: const Icon(Icons.more_vert, color: AppTheme.darkTextColor, size: 28),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuotesCard extends StatelessWidget {
  const _QuotesCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      shadowColor: Colors.orange.withAlpha(77),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEF4444)], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/Firefly.webp'),
                  fit: BoxFit.contain,
                )
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Quotes of the day", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("\"The best way to predict the future is to create it.\" - Peter Drucker", style: GoogleFonts.montserrat(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor)),
          TextButton(
            onPressed: onSeeAll,
            child: Row(children: [
              const Icon(Icons.check_box, size: 20, color: AppTheme.secondaryTextColor),
              const SizedBox(width: 4),
              Text("See All", style: GoogleFonts.montserrat(color: AppTheme.secondaryTextColor, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _RecruitmentItemCard extends StatelessWidget {
  final String title, subtitle, imagePath;
  final VoidCallback onClick;
  const _RecruitmentItemCard({required this.title, required this.subtitle, required this.imagePath, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.9 / 1.0,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                shadowColor: Colors.black.withAlpha(64),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.montserrat(color: AppTheme.darkTextColor, fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.montserrat(color: AppTheme.secondaryTextColor, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NewsItemCard extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback onClick;
  const _NewsItemCard({required this.title, required this.subtitle, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFFFF7ED),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Container(
                width: 80, 
                height: 80, 
                decoration: BoxDecoration(
                    color: AppTheme.darkTextColor, 
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/Firefly.webp'),
                      fit: BoxFit.cover,
                    )
                )
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor)),
                Text(subtitle, style: GoogleFonts.montserrat(fontSize: 14, color: AppTheme.secondaryTextColor)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: onClick,
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                  label: const Text("See More"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.darkTextColor,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                )
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}