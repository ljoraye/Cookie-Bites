import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Icons.grid_view_rounded, // Dashboard / Order Board
    Icons.add, // New Order
    Icons.receipt_long_outlined, // Expenses
    Icons.bar_chart_rounded, // Financials
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (index) {
            final isActive = index == currentIndex;
            return GestureDetector(
              onTap: () => onTap(index),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: isActive ? Colors.white : Colors.transparent,
                child: Icon(
                  _icons[index],
                  color: isActive ? AppColors.primary : Colors.white,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
