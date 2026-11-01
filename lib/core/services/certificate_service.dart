import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/models.dart';
import '../utils/format.dart';

class CertificateService {
  /// Membuat PDF sertifikat dan menyimpannya di penyimpanan aplikasi.
  Future<File> generate({
    required Donation donation,
    required String donorName,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Container(
          width: double.infinity,
          height: double.infinity,
          padding: const pw.EdgeInsets.all(32),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 2, color: PdfColors.red800),
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'SERTIFIKAT DONOR DARAH',
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red800,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Denyut - Jaringan Donor Darah Siaga'),
              pw.SizedBox(height: 40),
              pw.Text('Diberikan kepada'),
              pw.SizedBox(height: 8),
              pw.Text(
                donorName,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 24),
              pw.Text('atas donor darah golongan ${donation.bloodLabel}'),
              pw.SizedBox(height: 4),
              pw.Text('di ${donation.hospitalName}'),
              pw.SizedBox(height: 4),
              pw.Text('pada ${formatDate(donation.date)}'),
              pw.SizedBox(height: 40),
              pw.Text('Nomor: ${donation.certificateNo}'),
              pw.SizedBox(height: 40),
              pw.Text('Terima kasih telah menjadi bagian dari denyut kehidupan.'),
            ],
          ),
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sertifikat_${donation.certificateNo}.pdf');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  Future<void> share(File file) =>
      Share.shareXFiles([XFile(file.path)], text: 'Sertifikat donor darah');
}
