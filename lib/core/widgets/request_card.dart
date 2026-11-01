import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/format.dart';
import 'blood_type_badge.dart';
import 'urgency_chip.dart';

class RequestCard extends StatelessWidget {
  final BloodRequest request;
  final VoidCallback? onTap;
  final bool showStatus;

  const RequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = request;
    final distance = r.distanceKm > 0 ? '${r.distanceKm} km • ' : '';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              BloodTypeBadge(label: r.bloodLabel),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${r.component} • ${r.bagsNeeded} kantong',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(r.hospital.name),
                    const SizedBox(height: 4),
                    Text(
                      '$distance${formatRemaining(r.neededBy)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              showStatus
                  ? StatusChip(status: r.status)
                  : UrgencyChip(urgency: r.urgency),
            ],
          ),
        ),
      ),
    );
  }
}
