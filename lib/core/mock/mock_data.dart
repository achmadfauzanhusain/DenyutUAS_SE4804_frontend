import '../models/models.dart';

/// Data contoh dalam memori. Nanti diganti data dari REST API (layer data).
class MockData {
  static const currentUserId = 'me';

  static const hospitals = <Hospital>[
    Hospital(id: 'h1', name: 'RS Hasan Sadikin', city: 'Bandung', lat: -6.8970, lng: 107.6000),
    Hospital(id: 'h2', name: 'RS Borromeus', city: 'Bandung', lat: -6.8950, lng: 107.6130),
    Hospital(id: 'h3', name: 'RS Advent', city: 'Bandung', lat: -6.8900, lng: 107.5950),
    Hospital(id: 'h4', name: 'RS Santo Yusup', city: 'Bandung', lat: -6.9060, lng: 107.6320),
  ];

  static final UserProfile profile = UserProfile(
    fullName: 'Pengguna Demo',
    email: 'demo@denyut.id',
    phone: '081234567890',
    bloodType: 'O',
    rhesus: '-',
    birthDate: DateTime(2002, 5, 14),
    weightKg: 60,
    lastDonation: DateTime(2026, 6, 12),
    radiusKm: 10,
    homeAddress: 'Koordinat -6.9175, 107.6191',
  );

  static final List<BloodRequest> requests = [
    BloodRequest(
      id: 'r1', requesterId: 'u1', patientInitials: 'S.A.',
      bloodType: 'O', rhesus: '-', component: 'PRC', bagsNeeded: 2,
      hospital: hospitals[0], contactPhone: '081200000001',
      neededBy: DateTime.now().add(const Duration(hours: 5)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: RequestStatus.aktif, distanceKm: 4.2,
    ),
    BloodRequest(
      id: 'r2', requesterId: 'u2', patientInitials: 'M.R.',
      bloodType: 'B', rhesus: '+', component: 'Trombosit', bagsNeeded: 3,
      hospital: hospitals[1], contactPhone: '081200000002',
      neededBy: DateTime.now().add(const Duration(hours: 30)),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      status: RequestStatus.aktif, distanceKm: 7.8,
    ),
    BloodRequest(
      id: 'r3', requesterId: 'u3', patientInitials: 'D.P.',
      bloodType: 'A', rhesus: '+', component: 'Darah Lengkap', bagsNeeded: 1,
      hospital: hospitals[2], contactPhone: '081200000003',
      neededBy: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      status: RequestStatus.aktif, distanceKm: 12.5,
    ),
    // Permintaan milik pengguna demo
    BloodRequest(
      id: 'r4', requesterId: currentUserId, patientInitials: 'R.K.',
      bloodType: 'O', rhesus: '-', component: 'PRC', bagsNeeded: 2,
      hospital: hospitals[0], contactPhone: '081234567890',
      neededBy: DateTime.now().add(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: RequestStatus.aktif,
      donors: [
        DonorResponse(name: 'Budi', bloodLabel: 'O-', phone: '081311111111', etaMinutes: 30, distanceKm: 3.5),
        DonorResponse(name: 'Sari', bloodLabel: 'O-', phone: '081322222222', etaMinutes: 60, distanceKm: 6),
      ],
    ),
    BloodRequest(
      id: 'r5', requesterId: currentUserId, patientInitials: 'T.N.',
      bloodType: 'AB', rhesus: '+', component: 'PRC', bagsNeeded: 1,
      hospital: hospitals[3], contactPhone: '081234567890',
      neededBy: DateTime.now().add(const Duration(hours: 20)),
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      status: RequestStatus.menunggu,
    ),
    BloodRequest(
      id: 'r6', requesterId: currentUserId, patientInitials: 'L.H.',
      bloodType: 'B', rhesus: '-', component: 'Darah Lengkap', bagsNeeded: 1,
      hospital: hospitals[1], contactPhone: '081234567890',
      neededBy: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: RequestStatus.ditolak,
      rejectReason: 'Foto surat tidak terbaca, mohon unggah ulang dengan lebih jelas.',
    ),
    // Antrean verifikator (milik orang lain)
    BloodRequest(
      id: 'r7', requesterId: 'u4', patientInitials: 'A.S.',
      bloodType: 'A', rhesus: '-', component: 'PRC', bagsNeeded: 2,
      hospital: hospitals[2], contactPhone: '081200000007',
      neededBy: DateTime.now().add(const Duration(hours: 10)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: RequestStatus.menunggu,
    ),
    BloodRequest(
      id: 'r8', requesterId: 'u5', patientInitials: 'W.G.',
      bloodType: 'O', rhesus: '+', component: 'Trombosit', bagsNeeded: 4,
      hospital: hospitals[0], contactPhone: '081200000008',
      neededBy: DateTime.now().add(const Duration(hours: 4)),
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      status: RequestStatus.menunggu,
    ),
  ];

  static List<BloodRequest> get myRequests =>
      requests.where((r) => r.requesterId == currentUserId).toList().reversed.toList();

  static List<BloodRequest> get alerts => requests
      .where((r) => r.requesterId != currentUserId && r.status == RequestStatus.aktif)
      .toList();

  static List<BloodRequest> get activeRequests =>
      requests.where((r) => r.status == RequestStatus.aktif).toList();

  /// Terlama di atas (FR-VER-01).
  static List<BloodRequest> get pending {
    final list = requests.where((r) => r.status == RequestStatus.menunggu).toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  static final List<Donation> donations = [
    Donation(date: DateTime(2026, 6, 12), hospitalName: 'RS Hasan Sadikin', bloodLabel: 'O-', certificateNo: 'DNY-2026-0002'),
    Donation(date: DateTime(2026, 2, 20), hospitalName: 'RS Borromeus', bloodLabel: 'O-', certificateNo: 'DNY-2026-0001'),
  ];
}
