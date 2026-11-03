import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/blood_type_badge.dart';

class ProfilePage extends StatefulWidget {
  final bool isVerifier;
  const ProfilePage({super.key, this.isVerifier = false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final p = MockData.profile;
    final initial = p.fullName.isEmpty ? '?' : p.fullName[0].toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primary,
              child: Text(initial, style: const TextStyle(fontSize: 32, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(p.fullName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Center(child: Text(p.email, style: TextStyle(color: Colors.grey.shade600))),
          if (widget.isVerifier)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(child: Chip(label: Text('Verifikator'))),
            ),
          if (!widget.isVerifier) ...[
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: BloodTypeBadge(label: p.bloodLabel),
                title: Text(p.eligibilityText),
                subtitle: Text(
                  "Radius ${p.radiusKm} km • ${p.willing ? 'Bersedia dihubungi' : 'Tidak bersedia dihubungi'}",
                ),
              ),
            ),
            Card(
              color: Colors.amber.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Denyut bukan alat medis. Kelayakan donor berasal dari data yang kamu isi. '
                  'Pemeriksaan kesehatan, uji kecocokan darah, dan keputusan akhir tetap dilakukan oleh UTD atau rumah sakit.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Profil Donor'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.pushNamed(context, AppRouter.editDonorProfile, arguments: false);
                if (mounted) setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Donor'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, AppRouter.donationHistory),
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Keluar', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.login,
              (route) => false,
            ),
          ),
        ],
      ),
    );
  }
}
