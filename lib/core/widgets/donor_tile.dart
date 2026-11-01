import 'package:flutter/material.dart';
import '../models/models.dart';
import 'blood_type_badge.dart';

class DonorTile extends StatelessWidget {
  final DonorResponse donor;
  final Widget? trailing;
  const DonorTile({super.key, required this.donor, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: BloodTypeBadge(label: donor.bloodLabel, size: 44),
      title: Text(donor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        'Tiba ±${donor.etaMinutes} menit • ~${donor.distanceKm.round()} km\n${donor.phone}',
      ),
      isThreeLine: true,
      trailing: donor.completed
          ? const Icon(Icons.check_circle, color: Colors.green)
          : trailing,
    );
  }
}
