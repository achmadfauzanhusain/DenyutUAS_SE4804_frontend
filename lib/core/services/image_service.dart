import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

enum PhotoSource { camera, gallery }

/// Izin kamera atau galeri ditolak pengguna.
class PhotoPermissionException implements Exception {}

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Mengambil foto lalu mengompresnya. Mengembalikan null jika dibatalkan.
  Future<File?> pickLetterPhoto(PhotoSource source) async {
    XFile? picked;
    try {
      picked = await _picker.pickImage(
        source: source == PhotoSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 2000,
        maxHeight: 2000,
      );
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied' || e.code == 'photo_access_denied') {
        throw PhotoPermissionException();
      }
      rethrow;
    }
    if (picked == null) return null;
    return _compress(File(picked.path));
  }

  /// Jika kompresi gagal, file asli dipakai agar proses tidak berhenti.
  Future<File> _compress(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final target =
          '${dir.path}/surat_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        target,
        quality: 70,
        minWidth: 1280,
        minHeight: 1280,
      );
      return result == null ? file : File(result.path);
    } catch (_) {
      return file;
    }
  }
}
