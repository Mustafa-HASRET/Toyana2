import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/event_model.dart';

class EventRepository {
  final CollectionReference<Map<String, dynamic>> _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> addEvent(EventModel event) async {
    final data = event.toJson();

    if (event.createdAt == null) {
      data['createdAt'] = FieldValue.serverTimestamp();
    } else {
      data['createdAt'] = Timestamp.fromDate(event.createdAt!);
    }

    await _eventsCollection.add(data);
  }

  Stream<List<EventModel>> getEvents() {
    return _eventsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return EventModel.fromJson(data);
      }).toList();
    });
  }
}
