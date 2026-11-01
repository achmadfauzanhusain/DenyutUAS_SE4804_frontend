import 'package:flutter/material.dart';
import '../models/models.dart';
import '../navigation/app_shells.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/history/presentation/pages/donation_history_page.dart';
import '../../features/profile/presentation/pages/edit_donor_profile_page.dart';
import '../../features/profile/presentation/pages/pick_location_page.dart';
import '../../features/request/presentation/pages/create_request_page.dart';
import '../../features/request/presentation/pages/request_detail_page.dart';
import '../../features/request/presentation/pages/request_tracking_page.dart';
import '../../features/verification/presentation/pages/verification_detail_page.dart';

class AppRouter {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const editDonorProfile = '/edit-donor-profile'; // args: bool isSetup
  static const pickLocation = '/pick-location'; // args: PickedLocation?
  static const home = '/home';
  static const verifierHome = '/verifier';
  static const requestDetail = '/request-detail'; // args: BloodRequest
  static const createRequest = '/create-request';
  static const requestTracking = '/request-tracking'; // args: BloodRequest
  static const donationHistory = '/donation-history';
  static const verificationDetail = '/verification-detail'; // args: BloodRequest

  static Route<dynamic> onGenerateRoute(RouteSettings s) {
    final Widget page;
    switch (s.name) {
      case splash:
        page = const SplashPage();
      case onboarding:
        page = const OnboardingPage();
      case login:
        page = const LoginPage();
      case register:
        page = const RegisterPage();
      case editDonorProfile:
        page = EditDonorProfilePage(isSetup: s.arguments == true);
      case pickLocation:
        page = PickLocationPage(initial: s.arguments as PickedLocation?);
      case home:
        page = const UserShell();
      case verifierHome:
        page = const VerifierShell();
      case requestDetail:
        page = RequestDetailPage(request: s.arguments as BloodRequest);
      case createRequest:
        page = const CreateRequestPage();
      case requestTracking:
        page = RequestTrackingPage(request: s.arguments as BloodRequest);
      case donationHistory:
        page = const DonationHistoryPage();
      case verificationDetail:
        page = VerificationDetailPage(request: s.arguments as BloodRequest);
      default:
        page = const Scaffold(body: Center(child: Text('Halaman tidak ditemukan')));
    }
    return MaterialPageRoute(builder: (_) => page, settings: s);
  }
}
