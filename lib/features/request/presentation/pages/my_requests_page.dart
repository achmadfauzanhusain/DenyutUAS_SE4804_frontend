import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/request_card.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  Future<void> _create() async {
    final created = await Navigator.pushNamed(context, AppRouter.createRequest);
    if (!mounted) return;
    setState(() {});
    if (created == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permintaan dikirim, menunggu verifikasi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = MockData.myRequests;
    return Scaffold(
      appBar: AppBar(title: const Text('Permintaanku')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.add),
        label: const Text('Buat Permintaan'),
      ),
      body: list.isEmpty
          ? EmptyState(
              icon: Icons.bloodtype_outlined,
              title: 'Belum ada permintaan',
              message: 'Buat permintaan darah untuk keluarga pasien.',
              actionLabel: 'Buat Permintaan',
              onAction: _create,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                for (final r in list)
                  RequestCard(
                    request: r,
                    showStatus: true,
                    onTap: () async {
                      await Navigator.pushNamed(context, AppRouter.requestTracking, arguments: r);
                      if (mounted) setState(() {});
                    },
                  ),
              ],
            ),
    );
  }
}
