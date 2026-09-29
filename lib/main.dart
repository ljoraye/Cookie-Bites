// This is your app. It runs as it is: press run and you get the screen below.
//
// Nothing here is precious. Change the title, change the colors, delete the
// counter, add your own screens. It exists so that the repository is a working
// Flutter app from minute one instead of an empty folder.
//
// Everything in this file is Module 4 and 5 material: StatelessWidget,
// StatefulWidget, setState, Scaffold, AppBar, Column, Card, FilledButton.

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
    // DevicePreview draws a phone frame around your app, so it is judged at the
    // size it was designed for instead of stretched across a laptop window.
    //
    // It is left ON in the deployed build on purpose: your live link is opened
    // on a desktop browser, and a phone layout at full desktop width looks
    // broken when it is not. The toolbar also lets a visitor switch device and
    // orientation.
    //
    // Want the clean app with no frame instead (for a portfolio, or because
    // you made the layout properly responsive)? Add
    //   import 'package:flutter/foundation.dart' show kReleaseMode;
    // and set `enabled: !kReleaseMode`, which drops the frame in release builds.
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

      // These two lines are what make the DevicePreview toolbar actually
      // change the app. Keep them.
      locale: DevicePreview.locale(context),
      builder: (context, child) => DevicePreview.appBuilder(
        context,
        child,
      ),

      // Your design system starts here. See lib/theme/app_theme.dart for the
      // full Cookie Bites color palette, spacing scale, and type scale.
      theme: buildAppTheme(),

      home: const LoginPage(),
    );
  }
}