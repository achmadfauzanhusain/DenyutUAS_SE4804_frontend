import 'package:flutter/material.dart';
import '../utils/format.dart';

enum RequestStatus { menunggu, aktif, ditolak, terpenuhi, kedaluwarsa, dibatalkan }

extension RequestStatusX on RequestStatus {
  String get label => switch (this) {
        RequestStatus.menunggu => 'Menunggu Verifikasi',
        RequestStatus.aktif => 'Aktif',
        RequestStatus.ditolak => 'Ditolak',
        RequestStatus.terpenuhi => 'Terpenuhi',
        RequestStatus.kedaluwarsa => 'Kedaluwarsa',
        RequestStatus.dibatalkan => 'Dibatalkan',
      };

  Color get color => switch (this) {
        RequestStatus.menunggu => Colors.orange,
        RequestStatus.aktif => Colors.blue,
        RequestStatus.ditolak => Colors.red,
        RequestStatus.terpenuhi => Colors.green,
        RequestStatus.kedaluwarsa => Colors.grey,
        RequestStatus.dibatalkan => Colors.grey,
      };
}

enum Urgency { tinggi, sedang, rendah }

extension UrgencyX on Urgency {
  String get label => switch (this) {
        Urgency.tinggi => 'Urgensi Tinggi',
        Urgency.sedang => 'Urgensi Sedang',
        Urgency.rendah => 'Urgensi Rendah',
      };

  Color get color => switch (this) {
        Urgency.tinggi => Colors.red,
        Urgency.sedang => Colors.orange,
        Urgency.rendah => Colors.green,
      };
}

class Hospital {
  final String id, name, city;
  final double lat, lng;
  const Hospital({
    required this.id,
    required this.name,
    required this.city,
    required this.lat,
    required this.lng,
  });
}

class DonorResponse {
  final String name, bloodLabel, phone;
  final int etaMinutes;
  final double distanceKm;
  bool completed;

  DonorResponse({
    required this.name,
    required this.bloodLabel,
    required this.phone,
    required this.etaMinutes,
    required this.distanceKm,
    this.completed = false,
  });
}

class BloodRequest {
  final String id, requesterId, patientInitials, bloodType, rhesus;
  final String component, contactPhone;
  final int bagsNeeded;
  int bagsFulfilled;
  final Hospital hospital;
  final DateTime neededBy, createdAt;
  final double distanceKm;
  RequestStatus status;
  String? rejectReason;
  final List<DonorResponse> donors;
  final String? letterPath;

  BloodRequest({
    required this.id,
    required this.requesterId,
    required this.patientInitials,
    required this.bloodType,
    required this.rhesus,
    required this.component,
    required this.bagsNeeded,
    required this.hospital,
    required this.neededBy,
    required this.createdAt,
    required this.contactPhone,
    this.bagsFulfilled = 0,
    this.distanceKm = 0,
    this.status = RequestStatus.menunggu,
    this.rejectReason,
    this.letterPath,
    List<DonorResponse>? donors,
  }) : donors = donors ?? <DonorResponse>[];

  String get bloodLabel => '$bloodType$rhesus';

  bool get isOpen => status == RequestStatus.aktif;

  Urgency get urgency {
    final h = neededBy.difference(DateTime.now()).inHours;
    if (h < 6) return Urgency.tinggi;
    if (h < 24) return Urgency.sedang;
    return Urgency.rendah;
  }
}

class Donation {
  final DateTime date;
  final String hospitalName, bloodLabel, certificateNo;
  const Donation({
    required this.date,
    required this.hospitalName,
    required this.bloodLabel,
    required this.certificateNo,
  });
}

class UserProfile {
  String fullName, email, phone;
  String? bloodType, rhesus;
  DateTime? birthDate, lastDonation;
  double? weightKg;
  int radiusKm;
  bool willing;
  double homeLat, homeLng;
  String homeAddress;

  UserProfile({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.bloodType,
    this.rhesus,
    this.birthDate,
    this.lastDonation,
    this.weightKg,
    this.radiusKm = 10,
    this.willing = true,
    this.homeLat = -6.9175,
    this.homeLng = 107.6191,
    this.homeAddress = 'Belum dipilih',
  });

  // Default aturan (nanti dibaca dari tabel app_config di backend).
  static const int intervalDays = 90;
  static const int minAge = 17;
  static const int maxAge = 60;
  static const double minWeight = 45;

  String get bloodLabel => '${bloodType ?? '?'}${rhesus ?? ''}';

  int? get age {
    final b = birthDate;
    if (b == null) return null;
    final now = DateTime.now();
    var a = now.year - b.year;
    if (now.month < b.month || (now.month == b.month && now.day < b.day)) a--;
    return a;
  }

  /// null jika lolos kelayakan dasar, selain itu berisi alasan.
  String? get ineligibleReason {
    final a = age;
    final w = weightKg;
    if (a == null || w == null) return 'Data usia dan berat badan belum lengkap';
    if (a < minAge || a > maxAge) {
      return 'Usia donor harus $minAge sampai $maxAge tahun';
    }
    if (w < minWeight) return 'Berat badan minimal ${minWeight.toInt()} kg';
    return null;
  }

  bool get basicEligible => ineligibleReason == null;

  DateTime? get nextDonationDate =>
      lastDonation?.add(const Duration(days: intervalDays));

  bool get canDonateNow {
    if (!basicEligible) return false;
    final n = nextDonationDate;
    return n == null || !n.isAfter(DateTime.now());
  }

  String get eligibilityText {
    final r = ineligibleReason;
    if (r != null) return 'Status donor nonaktif: $r';
    if (canDonateNow) return 'Bisa donor sekarang';
    return 'Bisa donor lagi pada ${formatDate(nextDonationDate!)}';
  }
}
