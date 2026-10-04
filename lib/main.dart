import 'package:device_preview/device_preview.dart';
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
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const CookieBitesApp(),
    ),
  );
}

class CookieBitesApp extends StatelessWidget {
  const CookieBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cookie Bites',
      debugShowCheckedModeBanner: false,

      // These two lines make the DevicePreview toolbar actually change the app.
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: buildAppTheme(),
      home: const LoginPage(),
    );
  }
}