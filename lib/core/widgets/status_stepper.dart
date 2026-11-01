import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class StatusStepper extends StatelessWidget {
  final RequestStatus status;
  const StatusStepper({super.key, required this.status});

  static const _steps = [
    RequestStatus.menunggu,
    RequestStatus.aktif,
    RequestStatus.terpenuhi,
  ];

  @override
  Widget build(BuildContext context) {
    if (!_steps.contains(status)) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: status.color.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: status.color),
            const SizedBox(width: 8),
            Text(
              status.label,
              style: TextStyle(color: status.color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    final current = _steps.indexOf(status);
    return Column(
      children: [
        for (var i = 0; i < _steps.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  i <= current ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: i <= current ? AppTheme.primary : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  _steps[i].label,
                  style: TextStyle(
                    fontWeight: i == current ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
