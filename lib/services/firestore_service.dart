import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan koleksi events dengan converter
  CollectionReference<EventModel> _eventsCollection() {
    return _db.collection('events').withConverter<EventModel>(
          fromFirestore: (snapshots, _) =>
              EventModel.fromFirestore(snapshots.data()!, snapshots.id),
          toFirestore: (event, _) => event.toFirestore(),
        );
  }

  // Menambah event baru
  Future<void> addEvent(EventModel event) async {
    await _eventsCollection().add(event);
  }

  // Mengambil semua events berdasarkan kategori
  Future<List<EventModel>> getEvents(EventCategory category) async {
    final querySnapshot = await _eventsCollection()
        .where('category', isEqualTo: category.name)
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Mengambil semua OPREC events
  Future<List<EventModel>> getAllOprecEvents() async {
    return await getEvents(EventCategory.oprec);
  }

  // Mengambil semua News events
  Future<List<EventModel>> getAllNewsEvents() async {
    return await getEvents(EventCategory.news);
  }

  // Mengambil OPREC events berdasarkan jurusan
  Future<List<EventModel>> getOprecByMajor(String major) async {
    final querySnapshot = await _eventsCollection()
        .where('category', isEqualTo: EventCategory.oprec.name)
        .where('subtitle', isEqualTo: 'Jurusan: $major')
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // --- LOGIKA BARU UNTUK HISTORY ---

  // Menambahkan event ke riwayat tontonan pengguna
  Future<void> addEventToHistory(EventModel event) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final historyRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('viewHistory')
        .doc(event.id);

    // Menggunakan data dari event dan menambahkan timestamp kapan dilihat
    final historyData = event.toFirestore();
    historyData['viewedAt'] = FieldValue.serverTimestamp();

    await historyRef.set(historyData);
  }

  // Mengambil riwayat tontonan pengguna
  Future<List<EventModel>> getViewHistory() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final historySnapshot = await _db
        .collection('users')
        .doc(user.uid)
        .collection('viewHistory')
        // Urutkan berdasarkan kapan terakhir dilihat
        .orderBy('viewedAt', descending: true) 
        .get();

    // Ubah data dari riwayat menjadi objek EventModel
    return historySnapshot.docs
        .map((doc) => EventModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}