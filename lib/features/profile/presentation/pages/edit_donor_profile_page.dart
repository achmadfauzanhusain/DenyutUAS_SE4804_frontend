import 'package:flutter/material.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/models.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/primary_button.dart';
import 'pick_location_page.dart';

class EditDonorProfilePage extends StatefulWidget {
  /// true jika dibuka setelah registrasi (lanjut ke Beranda setelah simpan).
  final bool isSetup;
  const EditDonorProfilePage({super.key, this.isSetup = false});

  @override
  State<EditDonorProfilePage> createState() => _EditDonorProfilePageState();
}

class _EditDonorProfilePageState extends State<EditDonorProfilePage> {
  static const _bloodTypes = ['A', 'B', 'AB', 'O'];
  static const _rhesus = ['+', '-'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weight;
  String? _blood, _rh;
  DateTime? _birth, _last;
  late double _radius;
  late bool _willing;
  late double _lat, _lng;
  late String _address;

  @override
  void initState() {
    super.initState();
    final p = MockData.profile;
    _weight = TextEditingController(text: p.weightKg?.toString() ?? '');
    _blood = p.bloodType;
    _rh = p.rhesus;
    _birth = p.birthDate;
    _last = p.lastDonation;
    _radius = p.radiusKm.toDouble();
    _willing = p.willing;
    _lat = p.homeLat;
    _lng = p.homeLng;
    _address = p.homeAddress;
  }

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  double? get _weightValue => double.tryParse(_weight.text.replaceAll(',', '.'));

  Future<void> _pickLocation() async {
    final result = await Navigator.pushNamed(
      context,
      AppRouter.pickLocation,
      arguments: PickedLocation(lat: _lat, lng: _lng, address: _address),
    );
    if (result is PickedLocation) {
      setState(() {
        _lat = result.lat;
        _lng = result.lng;
        _address = result.address;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: PUT /profile (lewat repository -> dio).
    final p = MockData.profile;
    p.bloodType = _blood;
    p.rhesus = _rh;
    p.birthDate = _birth;
    p.weightKg = _weightValue;
    p.lastDonation = _last;
    p.radiusKm = _radius.round();
    p.willing = _willing;
    p.homeLat = _lat;
    p.homeLng = _lng;
    p.homeAddress = _address;

    if (widget.isSetup) {
      Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (r) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil donor disimpan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pratinjau kelayakan dasar secara langsung.
    String? warning;
    if (_birth != null && _weightValue != null) {
      warning = UserProfile(birthDate: _birth, weightKg: _weightValue).ineligibleReason;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSetup ? 'Lengkapi Profil Donor' : 'Edit Profil Donor'),
        automaticallyImplyLeading: !widget.isSetup,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isSetup)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Lengkapi profil agar kamu bisa dicocokkan dengan permintaan darah di sekitarmu.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _blood,
                        decoration: const InputDecoration(labelText: 'Golongan Darah'),
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
                _DateField(
                  label: 'Tanggal Lahir',
                  value: _birth,
                  required: true,
                  onChanged: (d) => setState(() => _birth = d),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weight,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Berat Badan (kg)',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    final w = double.tryParse((v ?? '').replaceAll(',', '.'));
                    if (w == null) return 'Berat badan harus berupa angka';
                    if (w < 20 || w > 250) return 'Berat badan tidak wajar';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _DateField(
                  label: 'Tanggal Donor Terakhir (opsional)',
                  value: _last,
                  clearable: true,
                  onChanged: (d) => setState(() => _last = d),
                ),
                if (warning != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Status donor akan nonaktif. $warning.'),
                  ),
                const SizedBox(height: 24),
                const Text('Domisili', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(_address),
                    trailing: TextButton(
                      onPressed: _pickLocation,
                      child: const Text('Pilih di Peta'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Radius jangkauan: ${_radius.round()} km',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _radius,
                  min: 5,
                  max: 30,
                  divisions: 25,
                  label: '${_radius.round()} km',
                  onChanged: (v) => setState(() => _radius = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Bersedia Dihubungi'),
                  subtitle: const Text('Jika mati, kamu tidak akan dicocokkan dengan permintaan.'),
                  value: _willing,
                  onChanged: (v) => setState(() => _willing = v),
                ),
                const SizedBox(height: 16),
                PrimaryButton(label: 'Simpan', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateField extends FormField<DateTime> {
  _DateField({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
    bool required = false,
    bool clearable = false,
  }) : super(
          initialValue: value,
          validator: required ? (v) => v == null ? '$label wajib diisi' : null : null,
          builder: (state) {
            return InkWell(
              onTap: () async {
                final d = await showDatePicker(
                  context: state.context,
                  initialDate: state.value ?? DateTime(2000),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (d != null) {
                  state.didChange(d);
                  onChanged(d);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: label,
                  errorText: state.errorText,
                  suffixIcon: clearable && state.value != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            state.didChange(null);
                            onChanged(null);
                          },
                        )
                      : const Icon(Icons.calendar_today),
                ),
                child: Text(
                  state.value == null ? 'Pilih tanggal' : formatDate(state.value!),
                ),
              ),
            );
          },
        );
}
