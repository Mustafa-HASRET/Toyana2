import 'package:flutter/material.dart';
import '../model/event_model.dart';

class EventCardWidget extends StatelessWidget {
  final EventModel event;

  const EventCardWidget({super.key, required this.event});

  String get _locationLabel => '${event.city}, ${event.district}';

  String get _dateLabel {
    if (event.date == null) return 'Tarih yok';
    final date = event.date!;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String get _timeLabel => event.time ?? 'Saat yok';

  String get _organizerLabel => event.organizer ?? 'Kullanıcı';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _locationLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.notifications, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Chip(
                  backgroundColor: Colors.blue.shade50,
                  avatar: const Icon(Icons.person, color: Colors.blue, size: 18),
                  label: Text(
                    _organizerLabel,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.location_on,
              text: _locationLabel,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.calendar_today,
              text: _dateLabel,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.access_time,
              text: _timeLabel,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.people,
              text: '${event.participantsCount} Katılımcı',
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: event.imagePath != null && event.imagePath!.isNotEmpty
                  ? Image.network(
                      event.imagePath!,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 170,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade700),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
