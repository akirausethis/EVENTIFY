import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify_flutter/core/model/event_model.dart';

class DummyDataGenerator {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> generateAndUploadDummyData() async {
    // Cek dulu apakah koleksi 'events' sudah ada isinya atau belum
    final eventsCollection = _db.collection('events');
    final snapshot = await eventsCollection.limit(1).get();
    
    // Jika sudah ada data, jangan lakukan apa-apa
    if (snapshot.docs.isNotEmpty) {
      print("Firestore already has data. Skipping dummy data generation.");
      return;
    }
    
    print("Firestore is empty. Generating dummy data...");

    // Menggunakan Batch Write untuk efisiensi
    final batch = _db.batch();

    // === 1. Generate 5 News ===
    final news = _getDummyNews();
    for (var event in news) {
      final docRef = eventsCollection.doc();
      batch.set(docRef, event.toFirestore());
    }

    // === 2. Generate 5 IO Events ===
    final ioEvents = _getDummyIoEvents();
    for (var event in ioEvents) {
      final docRef = eventsCollection.doc();
      batch.set(docRef, event.toFirestore());
    }

    // === 3. Generate 5 CR Events ===
    final crEvents = _getDummyCrEvents();
    for (var event in crEvents) {
      final docRef = eventsCollection.doc();
      batch.set(docRef, event.toFirestore());
    }

    // === 4. Generate 3 Oprec per Jurusan (total 36) ===
    final oprecEvents = _getDummyOprecEvents();
    for (var event in oprecEvents) {
      final docRef = eventsCollection.doc();
      batch.set(docRef, event.toFirestore());
    }

    // Commit semua data ke Firestore
    await batch.commit();
    print("Dummy data successfully uploaded to Firestore.");
  }

  // --- Kumpulan data dummy ---

  static final List<String> _majors = [
    "IMT", "ISB", "FIKOM", "IBM", "CB", "ACC", 
    "PSY", "MED", "FDB", "FTP", "LAW", "ARCH"
  ];

  List<EventModel> _getDummyNews() {
    return List.generate(5, (index) {
      final titles = [
        "UC Ranks Up in National University Ranking", "New Rector Inaugurated",
        "Library Extends Hours During Finals", "UC Basketball Team Wins Championship",
        "Research Grant Awarded to Medical Faculty"
      ];
      return EventModel(
        title: titles[index],
        subtitle: 'University News #${index + 1}',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.news,
        detailsContent: 'This is the full story for ${titles[index]}. Further details will be provided in the upcoming official circular.',
      );
    });
  }

  List<EventModel> _getDummyIoEvents() {
    return List.generate(5, (index) {
      final titles = [
        "Student Exchange to Seoul, South Korea", "Summer School in Tokyo, Japan",
        "Global Volunteer Project in Vietnam", "Model UN Conference in Singapore",
        "International Short Film Competition"
      ];
      return EventModel(
        title: titles[index],
        subtitle: 'International Office',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.io,
        detailsContent: 'An unparalleled opportunity to gain international exposure: ${titles[index]}.',
        registrationDate: '1 - 30 Agustus 2025',
        benefits: 'Global Networking, Cultural Immersion, Academic Credits (20 SKS), Certificate.',
        dDayDate: 'Departure in January 2026',
      );
    });
  }

  List<EventModel> _getDummyCrEvents() {
    return List.generate(5, (index) {
      final titles = [
        "Data Scientist Internship at GoTo", "Management Trainee at Unilever",
        "UI/UX Designer at Traveloka", "Campus Hiring by BCA",
        "Resume & LinkedIn Workshop"
      ];
      return EventModel(
        title: titles[index],
        subtitle: 'Career Center',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.cr,
        detailsContent: 'A golden opportunity to kickstart your professional journey: ${titles[index]}.',
        registrationDate: '10 - 25 Juli 2025',
        benefits: 'Valuable Experience, Networking with Professionals, Potential Job Offer.',
        dDayDate: 'Selection process will be held in early August 2025.',
      );
    });
  }
  
  List<EventModel> _getDummyOprecEvents() {
    return _majors.expand((major) => List.generate(3, (index) {
      final oprecTypes = [
        'Oprec Staff Himpunan', 'Panitia Acara Tahunan', 'Oprec Asisten Lab'
      ];
      return EventModel(
        title: '${oprecTypes[index]} $major', subtitle: 'Jurusan: $major',
        imagePath: 'assets/images/Firefly.webp', category: EventCategory.oprec,
        detailsContent: 'Jadilah bagian dari keluarga Himpunan Mahasiswa $major dan kembangkan soft skill-mu.',
        registrationDate: '1-15 Sep 2025', benefits: 'SKPK, Relasi, Leadership',
        conditions: 'Mahasiswa Aktif Jurusan $major Angkatan 2024 & 2025.', dDayDate: 'Interview: 20 Sep 2025'
      );
    })).toList();
  }
}