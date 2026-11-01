import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BloodTypeBadge extends StatelessWidget {
  final String label;
  final double size;
  const BloodTypeBadge({super.key, required this.label, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.34,
        ),
      ),
    );
  }
}
