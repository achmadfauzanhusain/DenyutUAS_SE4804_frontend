import 'package:flutter/material.dart';

class MapMarker {
  final double lat, lng;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  const MapMarker({
    required this.lat,
    required this.lng,
    required this.color,
    this.icon = Icons.location_on,
    this.onTap,
  });
}

/// Peta contoh tanpa package dan tanpa API key.
/// TODO: ganti dengan GoogleMap dari google_maps_flutter.
class FakeMap extends StatelessWidget {
  final List<MapMarker> markers;
  final double? pinLat, pinLng;
  final void Function(double lat, double lng)? onPick;

  const FakeMap({
    super.key,
    this.markers = const [],
    this.pinLat,
    this.pinLng,
    this.onPick,
  });

  static const _minLat = -6.95, _maxLat = -6.86;
  static const _minLng = 107.55, _maxLng = 107.68;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth, h = c.maxHeight;

      Offset toXY(double lat, double lng) => Offset(
            (lng - _minLng) / (_maxLng - _minLng) * w,
            (_maxLat - lat) / (_maxLat - _minLat) * h,
          );

      void pick(Offset p) {
        if (onPick == null) return;
        final lng = _minLng + (p.dx / w).clamp(0.0, 1.0) * (_maxLng - _minLng);
        final lat = _maxLat - (p.dy / h).clamp(0.0, 1.0) * (_maxLat - _minLat);
        onPick!(lat, lng);
      }

      Widget marker(double lat, double lng, Color color, IconData icon,
          VoidCallback? onTap) {
        final p = toXY(lat, lng);
        return Positioned(
          left: p.dx - 20,
          top: p.dy - 40,
          width: 40,
          height: 40,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Icon(icon, color: color, size: 40),
          ),
        );
      }

      return GestureDetector(
        onTapDown: onPick == null ? null : (d) => pick(d.localPosition),
        onPanUpdate: onPick == null ? null : (d) => pick(d.localPosition),
        child: ClipRect(
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _GridPainter())),
              for (final m in markers) marker(m.lat, m.lng, m.color, m.icon, m.onTap),
              if (pinLat != null && pinLng != null)
                marker(pinLat!, pinLng!, Colors.red, Icons.location_pin, null),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Peta contoh (placeholder google_maps_flutter)',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFE8F0E3));
    final line = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    for (double x = 0; x < size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
