import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/app_theme.dart';
import 'screens/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    const supabaseUrl = String.fromEnvironment('NEXT_PUBLIC_SUPABASE_URL', defaultValue: '');
    const supabaseAnonKey =
        String.fromEnvironment('NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY', defaultValue: '');

    print('DEBUG: NEXT_PUBLIC_SUPABASE_URL = $supabaseUrl');
    print('DEBUG: NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY = $supabaseAnonKey');

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Missing Supabase credentials. '
        'Ensure NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY are set via --dart-define.',
      );
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => const CookieBitesApp(),
      ),
    );
  } catch (e, stackTrace) {
    print('ERROR during initialization: $e');
    print('StackTrace: $stackTrace');
    // Show error in app
    runApp(ErrorApp(error: e.toString()));
  }
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
            const ColoredBox(color: AppColors.background),
            Image.asset('assets/images/background.png', fit: BoxFit.cover),
            previewChild,
          ],
        );
      },
      theme: buildAppTheme(),
      home: const LoginPage(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Initialization Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenience accessor used throughout the app's screens instead of typing
/// Supabase.instance.client everywhere.
final supabase = Supabase.instance.client;
