import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/models.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/blood_type_badge.dart';
import '../../../../core/widgets/fake_map.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/urgency_chip.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  void _showSummary(BuildContext context, BloodRequest r) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                BloodTypeBadge(label: r.bloodLabel),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${r.component} • ${r.bagsNeeded} kantong',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(r.hospital.name),
                    ],
                  ),
                ),
                UrgencyChip(urgency: r.urgency),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Lihat Detail',
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, AppRouter.requestDetail, arguments: r);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = MockData.profile;
    final markers = <MapMarker>[
      for (final r in MockData.activeRequests)
        MapMarker(
          lat: r.hospital.lat,
          lng: r.hospital.lng,
          color: r.urgency.color,
          onTap: () => _showSummary(context, r),
        ),
      MapMarker(
        lat: profile.homeLat,
        lng: profile.homeLng,
        color: Colors.blue,
        icon: Icons.home,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Peta Kebutuhan Darah')),
      body: Column(
        children: [
          Expanded(child: FakeMap(markers: markers)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                for (final u in Urgency.values) _Legend(color: u.color, label: u.label),
                const _Legend(color: Colors.blue, label: 'Domisilimu'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
