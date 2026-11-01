import 'package:flutter_test/flutter_test.dart';
import 'package:denyut/core/models/models.dart';

void main() {
  test('berat di bawah 45 kg tidak layak', () {
    final p = UserProfile(birthDate: DateTime(2000, 1, 1), weightKg: 44);
    expect(p.basicEligible, isFalse);
  });

  test('usia di bawah 17 tahun tidak layak', () {
    final p = UserProfile(
      birthDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      weightKg: 60,
    );
    expect(p.basicEligible, isFalse);
  });

  test('belum pernah donor dan data lengkap: bisa donor sekarang', () {
    final p = UserProfile(
      birthDate: DateTime(DateTime.now().year - 25, 1, 1),
      weightKg: 60,
    );
    expect(p.canDonateNow, isTrue);
  });

  test('masa jeda 90 hari belum terpenuhi', () {
    final p = UserProfile(
      birthDate: DateTime(DateTime.now().year - 25, 1, 1),
      weightKg: 60,
      lastDonation: DateTime.now().subtract(const Duration(days: 30)),
    );
    expect(p.canDonateNow, isFalse);
    expect(p.nextDonationDate!.isAfter(DateTime.now()), isTrue);
  });
}
