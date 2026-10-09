import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/app_theme.dart';
import 'screens/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Loads SUPABASE_URL / SUPABASE_ANON_KEY from .env for local runs. .env is
  // git-ignored, so a deployed build needs these passed a different way
  // instead (e.g. writing a .env from repository secrets as a build step).
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['NEXT_PUBLIC_SUPABASE_URL']!,
    anonKey: dotenv.env['NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY']!,
  );

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
      locale: DevicePreview.locale(context),
      builder: (context, child) {
        final previewChild = DevicePreview.appBuilder(context, child);
        return Stack(
          fit: StackFit.expand,
          children: [
            // Fallback color shows if the image is slow to load.
            const ColoredBox(color: AppColors.background),
            Image.asset('assets/images/background.png', fit: BoxFit.cover),
            // Optional soft overlay to keep text readable. Delete this line
            // if your image is already light.
            previewChild,
          ],
        );
      },
      theme: buildAppTheme(),
      home: const LoginPage(),
    );
  }
}

/// Convenience accessor used throughout the app's screens instead of typing
/// Supabase.instance.client everywhere.
final supabase = Supabase.instance.client;
