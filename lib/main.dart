import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() => runApp(const DenyutApp());

class DenyutApp extends StatelessWidget {
  const DenyutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Denyut',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
