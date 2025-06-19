import 'package:cloud_firestore/cloud_firestore.dart';

enum EventCategory { news, oprec, io, cr }

class EventModel {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final EventCategory category;
  
  final String detailsContent;
  final String? registrationDate;
  final String? benefits;
  final String? conditions;
  final String? dDayDate;

  EventModel({
    // ID tidak wajib di constructor karena akan dibuat oleh Firestore
    this.id = '', 
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.category,
    required this.detailsContent,
    this.registrationDate,
    this.benefits,
    this.conditions,
    this.dDayDate,
  });

  factory EventModel.fromFirestore(Map<String, dynamic> firestoreData, String docId) {
    return EventModel(
      id: docId,
      title: firestoreData['title'] ?? '',
      subtitle: firestoreData['subtitle'] ?? '',
      imagePath: firestoreData['imagePath'] ?? 'assets/images/Firefly.webp',
      category: EventCategory.values.byName(firestoreData['category'] ?? 'news'),
      detailsContent: firestoreData['detailsContent'] ?? '',
      registrationDate: firestoreData['registrationDate'],
      benefits: firestoreData['benefits'],
      conditions: firestoreData['conditions'],
      dDayDate: firestoreData['dDayDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
      'category': category.name,
      'detailsContent': detailsContent,
      if (registrationDate != null) 'registrationDate': registrationDate,
      if (benefits != null) 'benefits': benefits,
      if (conditions != null) 'conditions': conditions,
      if (dDayDate != null) 'dDayDate': dDayDate,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}