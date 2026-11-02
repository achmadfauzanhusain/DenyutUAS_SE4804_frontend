import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/models.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class CreateRequestPage extends StatefulWidget {
  const CreateRequestPage({super.key});

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  static const _bloodTypes = ['A', 'B', 'AB', 'O'];
  static const _rhesus = ['+', '-'];
  static const _components = ['Darah Lengkap', 'PRC', 'Trombosit'];
  static const _deadlines = {
    '3 jam': 3, '6 jam': 6, '12 jam': 12,
    '24 jam': 24, '3 hari': 72, '7 hari': 168,
  };

  final _formKey = GlobalKey<FormState>();
  final _initials = TextEditingController();
  final _imageService = ImageService();
  late final TextEditingController _phone =
      TextEditingController(text: MockData.profile.phone);

  String? _blood;
  String? _rh;
  String _component = 'PRC';
  int _bags = 1;
  Hospital? _hospital;
  String _deadline = '6 jam';
  File? _photo;
  bool _pickingPhoto = false;
  bool _loading = false;

  @override
  void dispose() {
    _initials.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickPhoto(PhotoSource source) async {
    setState(() => _pickingPhoto = true);
    try {
      final file = await _imageService.pickLetterPhoto(source);
      if (file != null && mounted) setState(() => _photo = file);
    } on PhotoPermissionException {
      _snack('Izin ditolak. Aktifkan izin di pengaturan atau pilih sumber lain (kamera/galeri).');
    } catch (_) {
      _snack('Gagal mengambil foto. Silakan coba lagi.');
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final active = MockData.myRequests
        .where((r) => r.status == RequestStatus.menunggu || r.status == RequestStatus.aktif)
        .length;
    if (active >= 3) {
      return _snack('Maksimal 3 permintaan aktif atau menunggu');
    }

    setState(() => _loading = true);
    // TODO: POST /requests (multipart, foto surat dikompres dulu).
    await Future.delayed(const Duration(milliseconds: 800));

    MockData.requests.add(BloodRequest(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      requesterId: MockData.currentUserId,
      patientInitials: _initials.text.trim().toUpperCase(),
      bloodType: _blood!,
      rhesus: _rh!,
      component: _component,
      bagsNeeded: _bags,
      hospital: _hospital!,
      contactPhone: _phone.text.trim(),
      letterPath: _photo?.path,
      neededBy: DateTime.now().add(Duration(hours: _deadlines[_deadline]!)),
      createdAt: DateTime.now(),
    ));

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Permintaan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Inisial Pasien (contoh: S.A.)',
                  controller: _initials,
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Inisial wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _blood,
                        decoration: const InputDecoration(labelText: 'Golongan'),
                        items: [for (final b in _bloodTypes) DropdownMenuItem(value: b, child: Text(b))],
                        onChanged: (v) => setState(() => _blood = v),
                        validator: (v) => v == null ? 'Wajib dipilih' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _rh,
                        decoration: const InputDecoration(labelText: 'Rhesus'),
                        items: [for (final r in _rhesus) DropdownMenuItem(value: r, child: Text(r))],
                        onChanged: (v) => setState(() => _rh = v),
                        validator: (v) => v == null ? 'Wajib dipilih' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _component,
                  decoration: const InputDecoration(labelText: 'Jenis Darah'),
                  items: [for (final c in _components) DropdownMenuItem(value: c, child: Text(c))],
                  onChanged: (v) => setState(() => _component = v!),
                ),
                const SizedBox(height: 16),
                InputDecorator(
                  decoration: const InputDecoration(labelText: 'Jumlah Kantong (1-10)'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _bags > 1 ? () => setState(() => _bags--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_bags', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: _bags < 10 ? () => setState(() => _bags++) : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Hospital>(
                  value: _hospital,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Rumah Sakit'),
                  items: [
                    for (final h in MockData.hospitals)
                      DropdownMenuItem(value: h, child: Text(h.name)),
                  ],
                  onChanged: (v) => setState(() => _hospital = v),
                  validator: (v) => v == null ? 'Rumah sakit wajib dipilih' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _deadline,
                  decoration: const InputDecoration(labelText: 'Dibutuhkan dalam'),
                  items: [for (final d in _deadlines.keys) DropdownMenuItem(value: d, child: Text(d))],
                  onChanged: (v) => setState(() => _deadline = v!),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Nomor Kontak',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return 'Nomor kontak wajib diisi';
                    if (!RegExp(r'^\d{9,15}$').hasMatch(s)) return 'Nomor tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text('Foto Surat Permintaan Darah',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _PhotoBox(
                  photo: _photo,
                  busy: _pickingPhoto,
                  onCamera: () => _pickPhoto(PhotoSource.camera),
                  onGallery: () => _pickPhoto(PhotoSource.gallery),
                  onRemove: () => setState(() => _photo = null),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Kirim Permintaan',
                  isLoading: _loading,
                  onPressed: _photo != null ? _submit : null,
                ),
                if (_photo == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Tombol aktif setelah foto surat dipilih.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoBox extends StatelessWidget {
  final File? photo;
  final bool busy;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRemove;

  const _PhotoBox({
    required this.photo,
    required this.busy,
    required this.onCamera,
    required this.onGallery,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content;
    if (busy) {
      content = const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (photo != null) {
      content = Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              photo!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  photo!.path.split('/').last,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Hapus'),
              ),
            ],
          ),
        ],
      );
    } else {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton.icon(
            onPressed: onCamera,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Kamera'),
          ),
          OutlinedButton.icon(
            onPressed: onGallery,
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Galeri'),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: content,
    );
  }
}
