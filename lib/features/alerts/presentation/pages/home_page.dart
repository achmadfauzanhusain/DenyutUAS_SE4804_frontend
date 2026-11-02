import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/request_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockData.profile;
    final alerts = MockData.alerts;
    final name = profile.fullName.split(' ').first;

    return Scaffold(
      appBar: AppBar(title: const Text('Peringatan untuk Saya')),
      body: alerts.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_none,
              title: 'Belum ada peringatan',
              message: 'Permintaan darah yang cocok denganmu akan muncul di sini.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: AppTheme.primary.withAlpha(20),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo, $name',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(profile.eligibilityText),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (final r in alerts)
                  RequestCard(
                    request: r,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouter.requestDetail,
                      arguments: r,
                    ),
                  ),
              ],
            ),
    );
  }
}
