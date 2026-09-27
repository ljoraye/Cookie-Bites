import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/summary_card.dart';
import '../widgets/user_header.dart';
import 'expenses_log_page.dart';
import 'order_board_page.dart';
import 'order_entry_form_page.dart';

class FinancialSummaryPage extends StatelessWidget {
  const FinancialSummaryPage({super.key});

  // TODO: replace every figure on this screen with real aggregates computed
  // from your Supabase `orders`/`expenses` tables once they're wired in.
  static const double _revenue = 13210;
  static const double _expenses = 4595;
  static const int _totalOrders = 35;
  static const int _paidOrders = 15;
  static const int _unpaidOrders = 20;

  static const _monthlyRevenue = {
    'April': 1800.0,
    'May': 3200.0,
    'June': 2600.0,
    'July': 4200.0,
  };
  static const _monthlyExpenses = {
    'April': 700.0,
    'May': 900.0,
    'June': 800.0,
    'July': 1100.0,
  };

  static const _topOrdered = [
    _TopProduct('Dubai', 20),
    _TopProduct('Matcha', 10),
    _TopProduct('Biscoff', 8),
  ];

  double get _netProfit => _revenue - _expenses;
  double get _margin => _revenue == 0 ? 0 : (_netProfit / _revenue) * 100;

  void _navigateToTab(BuildContext context, int index) {
    if (index == 3) return;
    late final Widget page;
    switch (index) {
      case 0:
        page = const OrderBoardPage();
        break;
      case 1:
        page = const OrderEntryFormPage();
        break;
      case 2:
        page = const ExpensesLogPage();
        break;
      default:
        return;
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  String _currentMonthLabel() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December', // ignore: lines_longer_than_80_chars
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = [
      ..._monthlyRevenue.values,
      ..._monthlyExpenses.values,
    ].reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: const UserHeader(name: 'LOUISE JACKSON'),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FINANCIALS',
              style: TextStyle(
                fontFamily: AppTextStyles.logoFontFamily,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NET PROFIT | ${_currentMonthLabel()}',
                    style: TextStyle(
                      color: AppColors.onSurface.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₱${_netProfit.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatChip(
                          label: 'Revenue',
                          value: '₱${_revenue.toStringAsFixed(0)}'),
                      const SizedBox(width: 16),
                      _StatChip(
                          label: 'Expenses',
                          value: '₱${_expenses.toStringAsFixed(0)}'),
                      const SizedBox(width: 16),
                      _StatChip(
                          label: 'Margin',
                          value: '${_margin.toStringAsFixed(1)}%'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Order',
                    value: '$_totalOrders',
                    showDot: false,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryCard(
                    title: 'Paid Orders',
                    value: '$_paidOrders',
                    showDot: false,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryCard(
                    title: 'Unpaid Orders',
                    value: '$_unpaidOrders',
                    showDot: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'MONTHLY TREND',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const Spacer(),
                      _LegendDot(color: AppColors.primary, label: 'Revenue'),
                      const SizedBox(width: 10),
                      _LegendDot(
                          color: AppColors.secondary, label: 'Expenses'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _monthlyRevenue.keys.map((month) {
                        final revenue = _monthlyRevenue[month] ?? 0;
                        final expense = _monthlyExpenses[month] ?? 0;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _Bar(
                                  height: maxValue == 0
                                      ? 2
                                      : (revenue / maxValue) * 90,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 3),
                                _Bar(
                                  height: maxValue == 0
                                      ? 2
                                      : (expense / maxValue) * 90,
                                  color: AppColors.secondary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              month.substring(0, 3),
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'TOP ORDERED',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _topOrdered.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final product = _topOrdered[index];
                  return _TopProductCard(product: product);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      bottomNavigationBar: AppNavBar(
        currentIndex: 3,
        onTap: (index) => _navigateToTab(context, index),
      ),
    );
  }
}

class _TopProduct {
  final String name;
  final int count;
  const _TopProduct(this.name, this.count);
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.onSurface.withOpacity(0.5),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;
  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: height.clamp(2, 200),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }
}

class _TopProductCard extends StatelessWidget {
  final _TopProduct product;
  const _TopProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.cookie_outlined, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${product.count}',
            style: TextStyle(
              color: AppColors.onSurface.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
