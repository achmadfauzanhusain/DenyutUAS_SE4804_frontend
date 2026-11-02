import 'package:flutter/material.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/donor_tile.dart';
import '../../../../core/widgets/request_card.dart';
import '../../../../core/widgets/status_stepper.dart';

class RequestTrackingPage extends StatefulWidget {
  final BloodRequest request;
  const RequestTrackingPage({super.key, required this.request});

  @override
  State<RequestTrackingPage> createState() => _RequestTrackingPageState();
}

class _RequestTrackingPageState extends State<RequestTrackingPage> {
  void _complete(DonorResponse d) {
    final r = widget.request;
    if (d.completed || r.bagsFulfilled >= r.bagsNeeded) return;
    // TODO: POST /responses/:id/complete
    setState(() {
      d.completed = true;
      r.bagsFulfilled++;
      if (r.bagsFulfilled >= r.bagsNeeded) r.status = RequestStatus.terpenuhi;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(r.status == RequestStatus.terpenuhi
            ? 'Semua kantong terpenuhi. Permintaan ditutup.'
            : 'Donor ${d.name} dikonfirmasi selesai.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    final showDonors =
        r.status == RequestStatus.aktif || r.status == RequestStatus.terpenuhi;

    return Scaffold(
      appBar: AppBar(title: const Text('Pelacakan Permintaan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RequestCard(request: r, showStatus: true),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StatusStepper(status: r.status),
            ),
          ),
          if (r.status == RequestStatus.ditolak && r.rejectReason != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Alasan penolakan: ${r.rejectReason}'),
              ),
            ),
          if (r.status == RequestStatus.menunggu)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Permintaan sedang diperiksa petugas. Kamu akan mendapat notifikasi setelah diverifikasi.'),
            ),
          if (showDonors) ...[
            const SizedBox(height: 8),
            Text('${r.bagsFulfilled} dari ${r.bagsNeeded} kantong terpenuhi',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: r.bagsFulfilled / r.bagsNeeded,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 24),
            const Text('Pendonor Bersedia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (r.donors.isEmpty)
              Text(
                'Belum ada pendonor dalam jangkauan. Coba bagikan permintaan ini ke kerabat.',
                style: TextStyle(color: Colors.grey.shade600),
              )
            else
              for (final d in r.donors)
                DonorTile(
                  donor: d,
                  trailing: r.status == RequestStatus.aktif
                      ? FilledButton.tonal(
                          onPressed: () => _complete(d),
                          child: const Text('Donor Selesai'),
                        )
                      : null,
                ),
          ],
        ],
      ),
    );
  }
}
