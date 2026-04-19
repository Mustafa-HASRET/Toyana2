import 'package:flutter/material.dart';

import 'common_widget/event_card_widget.dart';
import 'model/event_model.dart';
import 'repository/event_repository.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        backgroundColor: Colors.orange,
        centerTitle: false,
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: EventRepository().getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Hata: ${snapshot.error}'),
            );
          }

          final events = snapshot.data;
          if (events == null || events.isEmpty) {
            return const Center(
              child: Text(
                'Henüz etkinlik yok',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EventCardWidget(event: event),
              );
            },
          );
        },
      ),
    );
  }
}
