import 'package:url_launcher/url_launcher.dart';

/// Membuka aplikasi telepon dengan nomor terisi. false jika gagal.
Future<bool> callNumber(String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  try {
    return await launchUrl(uri);
  } catch (_) {
    return false;
  }
}
