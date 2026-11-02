import 'package:flutter/material.dart';
import '../../../../core/widgets/fake_map.dart';
import '../../../../core/widgets/primary_button.dart';

class PickedLocation {
  final double lat, lng;
  final String address;
  const PickedLocation({required this.lat, required this.lng, required this.address});
}

class PickLocationPage extends StatefulWidget {
  final PickedLocation? initial;
  const PickLocationPage({super.key, this.initial});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  late double _lat = widget.initial?.lat ?? -6.9175;
  late double _lng = widget.initial?.lng ?? 107.6191;

  // TODO: ambil alamat dari Google Geocoding API (dio).
  // Jika gagal, tampilkan koordinat (FR-GEO-01), seperti di bawah ini.
  String get _address => 'Koordinat ${_lat.toStringAsFixed(4)}, ${_lng.toStringAsFixed(4)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi Domisili')),
      body: Column(
        children: [
          Expanded(
            child: FakeMap(
              pinLat: _lat,
              pinLng: _lng,
              onPick: (lat, lng) => setState(() {
                _lat = lat;
                _lng = lng;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ketuk atau geser pada peta untuk memindahkan pin.'),
                const SizedBox(height: 4),
                Text(_address, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Simpan Lokasi',
                  onPressed: () => Navigator.pop(
                    context,
                    PickedLocation(lat: _lat, lng: _lng, address: _address),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
