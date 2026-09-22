import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_page.dart';

// TODO: once you've done your Supabase spike, initialize it here before
// runApp(), e.g.:
// await Supabase.initialize(
//   url: const String.fromEnvironment('SUPABASE_URL'),
//   anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
// );

void main() {
  runApp(const CookieBitesApp());
}

class CookieBitesApp extends StatelessWidget {
  const CookieBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cookie Bites',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LoginPage(),
    );
  }
}