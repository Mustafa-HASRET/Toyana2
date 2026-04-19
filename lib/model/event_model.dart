import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventName;
  final String title;
  final String description;
  final String city;
  final String district;
  final DateTime? date;
  final String? time;
  final String? imagePath;
  final String? organizer;
  final int participantsCount;
  final DateTime? createdAt;

  EventModel({
    required this.eventName,
    required this.title,
    required this.description,
    required this.city,
    required this.district,
    this.date,
    this.time,
    this.imagePath,
    this.organizer,
    this.participantsCount = 1,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'title': title,
      'description': description,
      'city': city,
      'district': district,
      'date': date?.toIso8601String(),
      'time': time,
      'imagePath': imagePath,
      'organizer': organizer,
      'participantsCount': participantsCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['createdAt'];
    DateTime? createdAt;
    if (createdAtValue is String) {
      createdAt = DateTime.tryParse(createdAtValue);
    } else if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    } else if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    }

    final dateValue = json['date'];
    DateTime? date;
    if (dateValue is String) {
      date = DateTime.tryParse(dateValue);
    } else if (dateValue is DateTime) {
      date = dateValue;
    } else if (dateValue is Timestamp) {
      date = dateValue.toDate();
    }

    return EventModel(
      eventName: json['eventName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      date: date,
      time: json['time'] as String?,
      imagePath: json['imagePath'] as String?,
      organizer: json['organizer'] as String?,
      participantsCount: json['participantsCount'] as int? ?? 1,
      createdAt: createdAt,
    );
  }
}
