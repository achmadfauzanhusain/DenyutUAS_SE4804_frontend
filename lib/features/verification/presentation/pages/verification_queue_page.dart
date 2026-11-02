import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/blood_type_badge.dart';
import '../../../../core/widgets/empty_state.dart';

class VerificationQueuePage extends StatefulWidget {
  const VerificationQueuePage({super.key});

  @override
  State<VerificationQueuePage> createState() => _VerificationQueuePageState();
}

class _VerificationQueuePageState extends State<VerificationQueuePage> {
  @override
  Widget build(BuildContext context) {
    final list = MockData.pending;
    return Scaffold(
      appBar: AppBar(title: const Text('Antrean Verifikasi')),
      body: list.isEmpty
          ? const EmptyState(
              icon: Icons.inbox_outlined,
              title: 'Antrean kosong',
              message: 'Tidak ada permintaan yang menunggu verifikasi.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final r in list)
                  Card(
                    child: ListTile(
                      leading: BloodTypeBadge(label: r.bloodLabel, size: 44),
                      title: Text('${r.component} • ${r.bagsNeeded} kantong'),
                      subtitle: Text('${r.hospital.name}\nDikirim ${formatAgo(r.createdAt)}'),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          AppRouter.verificationDetail,
                          arguments: r,
                        );
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}
