import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/info_row.dart';

class VerificationDetailPage extends StatelessWidget {
  final BloodRequest request;
  const VerificationDetailPage({super.key, required this.request});

  File? get _letterFile {
    final p = request.letterPath;
    if (p == null) return null;
    final f = File(p);
    return f.existsSync() ? f : null;
  }

  void _zoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Container(
            height: 400,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: _letterFile != null
                ? Image.file(_letterFile!, fit: BoxFit.contain)
                : const Icon(Icons.description, size: 160, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  void _approve(BuildContext context) {
    // TODO: PATCH /requests/:id/verify
    request.status = RequestStatus.aktif;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permintaan disetujui dan pencocokan pendonor dimulai')),
    );
    Navigator.pop(context);
  }

  Future<void> _reject(BuildContext context) async {
    final ctrl = TextEditingController();
    String? error;
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          title: const Text('Tolak Permintaan'),
          content: TextField(
            controller: ctrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Alasan penolakan',
              errorText: error,
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            FilledButton(
              onPressed: () {
                if (ctrl.text.trim().isEmpty) {
                  setDialog(() => error = 'Alasan wajib diisi');
                } else {
                  Navigator.pop(ctx, ctrl.text.trim());
                }
              },
              child: const Text('Tolak'),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    if (reason == null || !context.mounted) return;

    request.status = RequestStatus.ditolak;
    request.rejectReason = reason;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permintaan ditolak')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final r = request;
    return Scaffold(
      appBar: AppBar(title: const Text('Periksa Permintaan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () => _zoom(context),
            child: Container(
              height: 220,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _letterFile != null
                  ? Image.file(_letterFile!, fit: BoxFit.cover)
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description, size: 72, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Foto surat (ketuk untuk memperbesar)'),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          InfoRow(icon: Icons.bloodtype_outlined, label: 'Kebutuhan', value: '${r.component} ${r.bloodLabel} • ${r.bagsNeeded} kantong'),
          InfoRow(icon: Icons.person_outline, label: 'Pasien', value: r.patientInitials),
          InfoRow(icon: Icons.local_hospital_outlined, label: 'Rumah sakit', value: r.hospital.name),
          InfoRow(icon: Icons.schedule, label: 'Batas waktu', value: formatDateTime(r.neededBy)),
          InfoRow(icon: Icons.phone_outlined, label: 'Kontak pemohon', value: r.contactPhone),
          InfoRow(icon: Icons.send_outlined, label: 'Dikirim', value: formatAgo(r.createdAt)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => _reject(context),
                    child: const Text('Tolak'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: () => _approve(context),
                    child: const Text('Setujui'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
