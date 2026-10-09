import 'package:flutter/material.dart';
import '../main.dart';
import '../models/expense.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/summary_card.dart';
import '../widgets/user_header.dart';
import 'expenses_log_page.dart';
import 'monthly_financial_summary_page.dart';
import 'order_board_page.dart';
import 'order_entry_form_page.dart';

class FinancialSummaryPage extends StatefulWidget {
  const FinancialSummaryPage({super.key});

  @override
  State<FinancialSummaryPage> createState() => _FinancialSummaryPageState();
}

class _FinancialSummaryPageState extends State<FinancialSummaryPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  String? _error;

  double _revenue = 0;
  double _cogs = 0;
  double _expenses = 0;
  int _totalOrders = 0;
  int _paidOrders = 0;
  int _unpaidOrders = 0;

  Map<String, double> _monthlyRevenue = {};
  Map<String, double> _monthlyExpenses = {};
  List<_TopProduct> _topOrdered = [];

  // Net profit = paid revenue - cost of goods sold - other expenses.
  double get _netProfit => _revenue - _cogs - _expenses;

  double get _margin =>
      _revenue == 0 ? 0 : (_netProfit / _revenue) * 100;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('No signed-in user. Please log in again.');
      }

      final orderRows = await supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('order_date', ascending: false);

      final expenseRows = await supabase
          .from('expenses')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false);

      final orders = orderRows
          .map((row) => Order.fromMap(Map<String, dynamic>.from(row)))
          .toList();

      final expenses = expenseRows
          .map((row) => Expense.fromMap(Map<String, dynamic>.from(row)))
          .toList();

      _calculateSummary(orders, expenses);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _calculateSummary(
    List<Order> orders,
    List<Expense> expenses,
  ) {
    final now = DateTime.now();

    final currentMonthOrders = orders.where((order) {
      return order.deliveryDate.year == now.year &&
          order.deliveryDate.month == now.month;
    }).toList();

    final currentMonthExpenses = expenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList();

    // Only PAID orders count as revenue.
    _revenue = currentMonthOrders
        .where((order) => order.isPaid)
        .fold(
          0,
          (sum, order) => sum + order.total,
        );

    // Cost of goods sold for PAID orders.
    _cogs = currentMonthOrders
        .where((order) => order.isPaid)
        .fold(
          0,
          (sum, order) => sum + order.cogs,
        );

    // Other business expenses recorded for the current month.
    _expenses = currentMonthExpenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );

    _totalOrders = currentMonthOrders.length;
    _paidOrders = currentMonthOrders.where((order) => order.isPaid).length;
    _unpaidOrders = currentMonthOrders.where((order) => !order.isPaid).length;

    _calculateMonthlyData(orders, expenses);
    _calculateTopProducts(orders);
  }

  void _calculateMonthlyData(
    List<Order> orders,
    List<Expense> expenses,
  ) {
    final revenueByMonth = <String, double>{};
    final expensesByMonth = <String, double>{};

    // Only paid orders are included in revenue.
    for (final order in orders.where((order) => order.isPaid)) {
      final key = _monthKey(order.deliveryDate);
      revenueByMonth[key] =
          (revenueByMonth[key] ?? 0) + order.total;
    }

    for (final expense in expenses) {
      final key = _monthKey(expense.date);
      expensesByMonth[key] =
          (expensesByMonth[key] ?? 0) + expense.amount;
    }

    final keys = <String>{
      ...revenueByMonth.keys,
      ...expensesByMonth.keys,
    }.toList()
      ..sort();

    // Show the most recent four months, like the original mock screen.
    final recentKeys = keys.length > 4
        ? keys.sublist(keys.length - 4)
        : keys;

    _monthlyRevenue = {
      for (final key in recentKeys)
        _monthLabelFromKey(key): revenueByMonth[key] ?? 0,
    };

    _monthlyExpenses = {
      for (final key in recentKeys)
        _monthLabelFromKey(key): expensesByMonth[key] ?? 0,
    };
  }

  String _monthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  String _monthLabelFromKey(String key) {
    final parts = key.split('-');
    final month = int.parse(parts[1]);

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  void _calculateTopProducts(List<Order> orders) {
    final counts = <String, int>{};

    for (final order in orders) {
      for (final item in order.items) {
        counts[item.product] =
            (counts[item.product] ?? 0) + item.quantity;
      }
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _topOrdered = sorted
        .take(5)
        .map((entry) => _TopProduct(entry.key, entry.value))
        .toList();
  }

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

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MonthlyFinancialSummaryPage(),
      ),
    );
  }

  String _currentMonthLabel() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
      backgroundColor: Colors.transparent,
        appBar: UserHeader(
          name: 'LOUISE JACKSON',
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: AppNavBar(
          currentIndex: 3,
          onTap: (index) => _navigateToTab(context, index),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        backgroundColor: Colors.transparent,
        appBar: UserHeader(
          name: 'LOUISE JACKSON',
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Unable to load financial summary.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: _loadSummary,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AppNavBar(
          currentIndex: 3,
          onTap: (index) => _navigateToTab(context, index),
        ),
      );
    }

    final allMonthlyValues = [
      ..._monthlyRevenue.values,
      ..._monthlyExpenses.values,
    ];

    final maxValue = allMonthlyValues.isEmpty
        ? 0.0
        : allMonthlyValues.reduce((a, b) => a > b ? a : b);

    final monthLabels = _monthlyRevenue.keys.toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: UserHeader(
        name: 'LOUISE JACKSON',
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _loadSummary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'FINANCIALS',
                    style: TextStyle(
                      fontFamily: AppTextStyles.logoFontFamily,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _openHistory,
                    icon: Icon(Icons.history, color: AppColors.primary),
                    label: Text(
                      'History',
                      style: TextStyle(color: AppColors.primary),
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
                  border: Border.all(color: AppColors.primary, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
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
                        color: AppColors.onSurface.withValues(alpha: 0.6),
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
                          value: '₱${_revenue.toStringAsFixed(0)}',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          label: 'COGS',
                          value: '₱${_cogs.toStringAsFixed(0)}',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          label: 'Expenses',
                          value: '₱${_expenses.toStringAsFixed(0)}',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          label: 'Margin',
                          value: '${_margin.toStringAsFixed(1)}%',
                        ),
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
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'MONTHLY TREND',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        _LegendDot(
                          color: AppColors.primary,
                          label: 'Revenue',
                        ),
                        const SizedBox(width: 10),
                        _LegendDot(
                          color: AppColors.secondary,
                          label: 'Expenses',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 120,
                      child: monthLabels.isEmpty
                          ? const Center(
                              child: Text('No monthly data yet.'),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: monthLabels.map((month) {
                                final revenue = _monthlyRevenue[month] ?? 0;
                                final expense = _monthlyExpenses[month] ?? 0;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                        color: AppColors.onSurface
                                            .withValues(alpha: 0.6),
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
                child: _topOrdered.isEmpty
                    ? const Center(
                        child: Text('No ordered products yet.'),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _topOrdered.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: 10),
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
            color: AppColors.onSurface.withValues(alpha: 0.5),
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
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
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(3),
        ),
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
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.cookie_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${product.count}',
            style: TextStyle(
              color: AppColors.onSurface.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
