import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _items = [
    _OnboardItem(
      icon: Icons.verified_user,
      title: 'Permintaan Terverifikasi',
      body:
          'Setiap permintaan darah diperiksa petugas berdasarkan foto surat dari rumah sakit sebelum disebarkan.',
    ),
    _OnboardItem(
      icon: Icons.location_on,
      title: 'Pendonor yang Cocok & Dekat',
      body:
          'Sistem mencocokkan golongan darah, rhesus, masa jeda, dan jarak, sehingga hanya pendonor yang tepat yang dihubungi.',
    ),
    _OnboardItem(
      icon: Icons.medical_information,
      title: 'Penting Diketahui',
      body:
          'Denyut bukan alat medis. Kelayakan donor berasal dari data yang kamu isi. Pemeriksaan kesehatan, uji kecocokan darah, dan keputusan akhir tetap dilakukan oleh UTD atau rumah sakit.',
    ),
  ];

  bool get _isLast => _index == _items.length - 1;

  void _next() {
    if (_isLast) {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLast
                    ? null
                    : () => _controller.animateToPage(
                          _items.length - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                child: Text(_isLast ? '' : 'Lewati'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _items.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _items[i],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: i == _index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: i == _index ? AppTheme.primary : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                label: _isLast ? 'Saya Mengerti' : 'Lanjut',
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _OnboardItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 110, color: AppTheme.primary),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
