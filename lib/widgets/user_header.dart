import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserHeader extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String role;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;

  const UserHeader({
    super.key,
    required this.name,
    required this.role,
    this.onMenuTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: onMenuTap,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: onProfileTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
