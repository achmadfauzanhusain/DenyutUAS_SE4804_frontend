import 'package:flutter/material.dart';
import '../models/models.dart';

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class UrgencyChip extends StatelessWidget {
  final Urgency urgency;
  const UrgencyChip({super.key, required this.urgency});

  @override
  Widget build(BuildContext context) => _Pill(urgency.label, urgency.color);
}

class StatusChip extends StatelessWidget {
  final RequestStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) => _Pill(status.label, status.color);
}
