import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/models.dart';
import '../../../../core/services/phone_launcher.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/blood_type_badge.dart';
import '../../../../core/widgets/info_row.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/urgency_chip.dart';

class RequestDetailPage extends StatefulWidget {
  final BloodRequest request;
  const RequestDetailPage({super.key, required this.request});

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  bool _willing = false;
  bool _declined = false;
  int _eta = 30;

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _call(String phone) async {
    final ok = await callNumber(phone);
    if (!ok && mounted) _snack('Tidak dapat membuka aplikasi telepon');
  }

  void _confirmWilling(int eta) {
    final r = widget.request;
    // Simulasi penolakan server (FR-RESP-03).
    if (!r.isOpen) return _snack('Permintaan sudah tidak aktif');
    if (r.bagsFulfilled >= r.bagsNeeded) return _snack('Kuota kantong sudah penuh');
    if (!MockData.profile.canDonateNow) {
      return _snack('Belum layak donor. ${MockData.profile.eligibilityText}');
    }
    // TODO: POST /requests/:id/respond
    setState(() {
      _willing = true;
      _eta = eta;
    });
    _snack('Terima kasih! Pemohon akan melihat kesediaanmu.');
  }

  void _openRespondSheet() {
    int eta = 30;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Respons Permintaan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Perkiraan tiba jika bersedia:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final m in const [30, 60, 120])
                    ChoiceChip(
                      label: Text('$m menit'),
                      selected: eta == m,
                      onSelected: (_) => setSheet(() => eta = m),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Bersedia',
                onPressed: () {
                  Navigator.pop(ctx);
                  _confirmWilling(eta);
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => _declined = true);
                  },
                  child: const Text('Tidak Bisa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    final responded = _willing || _declined;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Permintaan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              BloodTypeBadge(label: r.bloodLabel, size: 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.component,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${r.bagsNeeded} kantong dibutuhkan'),
                  ],
                ),
              ),
              UrgencyChip(urgency: r.urgency),
            ],
          ),
          const SizedBox(height: 16),
          if (!r.isOpen)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline),
                  SizedBox(width: 8),
                  Text('Permintaan sudah ditutup'),
                ],
              ),
            ),
          InfoRow(icon: Icons.local_hospital_outlined, label: 'Rumah sakit', value: '${r.hospital.name}, ${r.hospital.city}'),
          InfoRow(icon: Icons.near_me_outlined, label: 'Jarak dari domisilimu', value: '${r.distanceKm} km'),
          InfoRow(icon: Icons.schedule, label: 'Batas waktu', value: '${formatDateTime(r.neededBy)} (${formatRemaining(r.neededBy)})'),
          InfoRow(icon: Icons.bloodtype_outlined, label: 'Terpenuhi', value: '${r.bagsFulfilled} dari ${r.bagsNeeded} kantong'),
          InfoRow(icon: Icons.person_outline, label: 'Pasien', value: r.patientInitials),
          const SizedBox(height: 16),
          if (_willing)
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kamu bersedia, tiba ±$_eta menit',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Kontak pemohon: ${r.contactPhone}'),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () => _call(r.contactPhone),
                      icon: const Icon(Icons.call),
                      label: const Text('Hubungi'),
                    ),
                  ],
                ),
              ),
            )
          else if (_declined)
            const Text('Kamu menjawab: Tidak Bisa', textAlign: TextAlign.center)
          else
            PrimaryButton(
              label: 'Respons',
              onPressed: r.isOpen && !responded ? _openRespondSheet : null,
            ),
        ],
      ),
    );
  }
}
