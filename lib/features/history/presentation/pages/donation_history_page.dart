import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/models.dart';
import '../../../../core/services/certificate_service.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/blood_type_badge.dart';
import '../../../../core/widgets/empty_state.dart';

class DonationHistoryPage extends StatelessWidget {
  const DonationHistoryPage({super.key});

  Future<void> _download(BuildContext context, Donation d) async {
    final service = CertificateService();
    try {
      final file = await service.generate(
        donation: d,
        donorName: MockData.profile.fullName,
      );
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Sertifikat tersimpan'),
          content: Text(
            'Nama file: ${file.path.split('/').last}\n\nLokasi:\n${file.path}',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                service.share(file);
              },
              child: const Text('Bagikan'),
            ),
          ],
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat sertifikat. Silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = MockData.donations;
    final profile = MockData.profile;
    final next = profile.nextDonationDate;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Donor')),
      body: list.isEmpty
          ? const EmptyState(
              icon: Icons.history,
              title: 'Belum ada riwayat donor',
              message: 'Donasi yang sudah dikonfirmasi akan muncul di sini.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Stat(label: 'Total donasi', value: '${list.length}'),
                        _Stat(
                          label: 'Layak berikutnya',
                          value: next == null ? 'Sekarang' : formatDate(next),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                for (final d in list)
                  Card(
                    child: ListTile(
                      leading: BloodTypeBadge(label: d.bloodLabel, size: 44),
                      title: Text(d.hospitalName),
                      subtitle: Text('${formatDate(d.date)} • ${d.certificateNo}'),
                      trailing: IconButton(
                        tooltip: 'Unduh sertifikat',
                        icon: const Icon(Icons.download),
                        onPressed: () => _download(context, d),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}
