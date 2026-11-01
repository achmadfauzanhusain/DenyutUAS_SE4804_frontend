import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:denyut/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('Login menampilkan pesan error saat form kosong', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    await tester.tap(find.text('Masuk'));
    await tester.pump();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });
}
