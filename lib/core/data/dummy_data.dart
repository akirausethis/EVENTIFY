import 'package:eventify_flutter/core/model/event_model.dart';

class DummyDataService {
  // === 12 JURUSAN SESUAI PERMINTAAN ===
  static final List<String> majors = [
    "IMT", "ISB", "FIKOM", "IBM", "CB", "ACC", "PSY", "MED", "FDB", "FTP", "LAW", "ARCH"
  ];

  // === 15 DATA UNTUK NEWS ===
  static final List<EventModel> allNews = List.generate(
    15,
    (index) {
      final titles = [
        "UC Ranks Up in National University Ranking", "New Rector Inaugurated for 2025-2030 Period",
        "Library Extends Operational Hours During Finals", "UC Basketball Team Wins National Championship",
        "Research Grant Awarded to Medical Faculty", "Annual Charity Run Breaks Fundraising Record",
        "New 'Technopreneurship' Course Launched", "UC Choir to Perform at International Festival",
        "Campus Greening Initiative Starts This Month", "Cybersecurity Workshop for All Students",
        "Mental Health Awareness Week Announced", "Alumni Gathering Event Date Set",
        "UC Launches New Mobile App for Students", "Partnership with a Global Tech Company",
        "Art & Design Exhibition Opens Next Week"
      ];
      return EventModel(
        id: 'news_$index',
        title: titles[index % titles.length],
        subtitle: 'University News #${index + 1}',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.news,
        detailsContent: 'This is the full story for ${titles[index % titles.length]}. This news covers significant developments within our university community, aiming to keep all students and staff well-informed. Further details will be provided in the upcoming official circular.',
      );
    },
  );

  // === 15 DATA UNTUK INTERNATIONAL OFFICE ===
  static final List<EventModel> allIoEvents = List.generate(
    15,
    (index) {
      final titles = [
        "Student Exchange to Seoul, South Korea", "Summer School Program in Tokyo, Japan",
        "Global Volunteer Project in Vietnam", "Model United Nations Conference in Singapore",
        "International Short Film Competition", "ASEAN Student Leaders Forum",
        "Scholarship Info Session: Europe", "Cultural Exchange with Australian Universities",
        "Winter Program in Germany", "Global Entrepreneurship Challenge",
        "Tech Innovation Summit in Silicon Valley", "World Youth Debate Championship",
        "International Case Competition", "Study Tour to China's Tech Hubs", "Joint Research Program with MIT"
      ];
      return EventModel(
        id: 'io_$index',
        title: titles[index % titles.length],
        subtitle: 'International Office',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.io,
        detailsContent: 'An unparalleled opportunity to gain international exposure. ${titles[index % titles.length]} is designed for proactive students eager to broaden their horizons.',
        registrationDate: '1 - 30 Agustus 2025',
        benefits: 'Global Networking, Cultural Immersion, Academic Credits (20 SKS), Certificate.',
        dDayDate: 'Departure in January 2026',
      );
    },
  );

  // === 15 DATA UNTUK CAREER CENTER ===
  static final List<EventModel> allCrEvents = List.generate(
    15,
    (index) {
      final titles = [
        "Data Scientist Internship at GoTo", "Management Trainee at Unilever",
        "UI/UX Designer at Traveloka", "Campus Hiring by BCA",
        "Resume & LinkedIn Workshop", "Virtual Job Fair 2025",
        "Investment Banking Career Talk", "Software Engineer (Full-time) at Microsoft",
        "Product Manager at a Leading Startup", "Digital Marketing Seminar",
        "Company Visit to Sampoerna Tbk.", "Audit Associate at PwC",
        "Consulting 101 with BCG", "How to Ace Your Interview", "Personal Branding for Career Success"
      ];
      return EventModel(
        id: 'cr_$index',
        title: titles[index % titles.length],
        subtitle: 'Career Center',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.cr,
        detailsContent: 'A golden opportunity to kickstart your professional journey. ${titles[index % titles.length]} is brought to you by the Career Center to bridge the gap between academic life and the professional world.',
        registrationDate: '10 - 25 Juli 2025',
        benefits: 'Valuable Experience, Networking with Professionals, Potential Job Offer.',
        dDayDate: 'Selection process will be held in early August 2025.',
      );
    },
  );

  // === DATA UNTUK OPEN RECRUITMENT (3 PER JURUSAN, TOTAL 36) ===
  static final List<EventModel> allOprecEvents = majors.expand((major) => [
    EventModel(
      id: 'oprec_${major}_1', title: 'Oprec Staff Himpunan $major', subtitle: 'Jurusan: $major',
      imagePath: 'assets/images/Firefly.webp', category: EventCategory.oprec,
      detailsContent: 'Jadilah bagian dari keluarga Himpunan Mahasiswa $major dan kembangkan soft skill-mu.',
      registrationDate: '1-10 Sep 2025', benefits: 'SKPK, Relasi, Leadership',
      conditions: 'Mahasiswa Aktif Jurusan $major Angkatan 2024 & 2025.', dDayDate: 'Interview: 15 Sep 2025'
    ),
    EventModel(
      id: 'oprec_${major}_2', title: 'Panitia Acara Tahunan $major', subtitle: 'Jurusan: $major',
      imagePath: 'assets/images/Firefly.webp', category: EventCategory.oprec,
      detailsContent: 'Dicari panitia yang bersemangat untuk menyukseskan acara tahunan terbesar dari jurusan $major.',
      registrationDate: '1-15 Sep 2025', benefits: 'SKPK, Pengalaman Event, Sertifikat Panitia',
      conditions: 'Terbuka untuk semua angkatan jurusan $major.', dDayDate: 'Rapat Perdana: 20 Sep 2025'
    ),
    EventModel(
      id: 'oprec_${major}_3', title: 'Oprec Asisten Laboratorium $major', subtitle: 'Jurusan: $major',
      imagePath: 'assets/images/Firefly.webp', category: EventCategory.oprec,
      detailsContent: 'Bantu adik kelasmu, perdalam ilmumu, dan dapatkan pengalaman mengajar sebagai asisten lab.',
      registrationDate: '20-30 Agu 2025', benefits: 'Honor, Pengalaman Mengajar, Surat Referensi',
      conditions: 'Menguasai mata kuliah praktikum terkait, IPK > 3.25', dDayDate: 'Tes Tulis: 5 Sep 2025'
    ),
  ]).toList();
  
  // Fungsi untuk mengambil data berdasarkan kategori
  static List<EventModel> getEvents(EventCategory category) {
    switch (category) {
      case EventCategory.news:
        return allNews;
      case EventCategory.oprec:
        return allOprecEvents;
      case EventCategory.io:
        return allIoEvents;
      case EventCategory.cr:
        return allCrEvents;
    }
  }

  // Fungsi untuk mengambil oprec berdasarkan jurusan
  static List<EventModel> getOprecByMajor(String major) {
    return allOprecEvents.where((event) => event.subtitle.contains(major)).toList();
  }
}