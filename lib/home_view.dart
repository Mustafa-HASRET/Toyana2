import 'package:flutter/material.dart';

import 'common_widget/event_card_widget.dart';
import 'model/event_model.dart';
import 'repository/event_repository.dart';

const Color _successGreen = Color(0xFF4CAF50);

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Merhaba!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Yakınınızdaki etkinlikleri keşfedin.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _successGreen,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.06),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.location_on, color: _successGreen),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ankara, Mamak',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Öne çıkan etkinlikler',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<EventModel>>(
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
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.event_available, size: 72, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Henüz etkinlik yok',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: events.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return EventCardWidget(event: event);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
