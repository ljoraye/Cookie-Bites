import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/profile_page.dart';
import '../screens/previous_orders_page.dart';
import '../screens/financial_summary_page.dart';
import '../screens/manage_products_page.dart';
import '../screens/login_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              color: AppColors.primary,
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'LOUISE JACKSON',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            _DrawerItem(
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () => _push(context, const ProfilePage()),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => _push(context, const SettingsPage()),
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.receipt_long_outlined,
              label: 'Previous Orders',
              onTap: () => _push(context, const PreviousOrdersPage()),
            ),
            _DrawerItem(
              icon: Icons.calendar_month_outlined,
              label: 'Financial Summary by Month',
              onTap: () => _push(context, const FinancialSummaryPage()),
            ),
            _DrawerItem(
              icon: Icons.cookie_outlined,
              label: 'Manage Products',
              onTap: () => _push(context, const ManageProductsPage()),
            ),
            const Spacer(),
            const Divider(),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Log out',
              onTap: () {
                // TODO: once Supabase auth is wired in, call
                // Supabase.instance.client.auth.signOut() here first.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).pop(); // close the drawer first
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Settings coming soon.'),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
