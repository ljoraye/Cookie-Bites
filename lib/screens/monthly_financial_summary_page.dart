import 'package:flutter/material.dart';
import '../main.dart';
import '../models/expense.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/summary_card.dart';

/// History of monthly financials. Opened from FinancialSummaryPage.
class MonthlyFinancialSummaryPage extends StatefulWidget {
  const MonthlyFinancialSummaryPage({super.key});

  @override
  State<MonthlyFinancialSummaryPage> createState() =>
      _MonthlyFinancialSummaryPageState();
}

class _MonthlyFinancialSummaryPageState
    extends State<MonthlyFinancialSummaryPage> {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  bool _isLoading = true;
  String? _error;

  /// Sorted newest -> oldest.
  List<_MonthSummary> _history = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
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

      final history = _buildHistory(orders, expenses);

      if (!mounted) return;
      setState(() {
        _history = history;
        _selectedIndex = 0;
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

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  List<_MonthSummary> _buildHistory(
    List<Order> orders,
    List<Expense> expenses,
  ) {
    final map = <String, _MonthSummary>{};

    _MonthSummary bucket(DateTime d) => map.putIfAbsent(
          _key(d),
          () => _MonthSummary(year: d.year, month: d.month),
        );

    // Same month rule as FinancialSummaryPage: group by delivery date.
    for (final order in orders) {
      final m = bucket(order.deliveryDate);
      m.totalOrders++;
      if (order.isPaid) {
        m.paidOrders++;
        m.revenue += order.total;
        m.cogs += order.cogs;
      } else {
        m.unpaidOrders++;
        m.unpaidAmount += order.total;
      }
      for (final item in order.items) {
        m.products[item.product] =
            (m.products[item.product] ?? 0) + item.quantity;
      }
    }

    for (final expense in expenses) {
      bucket(expense.date).expenses += expense.amount;
    }

    final list = map.values.toList()
      ..sort((a, b) {
        final byYear = b.year.compareTo(a.year);
        return byYear != 0 ? byYear : b.month.compareTo(a.month);
      });
    return list;
  }

  String _label(_MonthSummary m) => '${_months[m.month - 1]} ${m.year}';
  String _shortLabel(_MonthSummary m) =>
      '${_months[m.month - 1].substring(0, 3)} ${m.year}';
  String _peso(double v) => '₱${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.onSurface),
        title: Text(
          'MONTHLY HISTORY',
          style: TextStyle(
            fontFamily: AppTextStyles.logoFontFamily,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Unable to load monthly history.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_history.isEmpty) {
      return const Center(child: Text('No sales history yet.'));
    }

    final selected = _history[_selectedIndex];

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(selected),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Order',
                    value: '${selected.totalOrders}',
                    showDot: false,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryCard(
                    title: 'Paid Orders',
                    value: '${selected.paidOrders}',
                    showDot: false,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryCard(
                    title: 'Unpaid Orders',
                    value: '${selected.unpaidOrders}',
                    showDot: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildTopProducts(selected),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'ALL MONTHS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(_history.length, _buildMonthRow),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _history.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = i == _selectedIndex;
          return ChoiceChip(
            label: Text(_shortLabel(_history[i])),
            selected: isSelected,
            selectedColor: AppColors.primary.withValues(alpha: 0.25),
            backgroundColor: AppColors.surface,
            side: BorderSide(color: AppColors.primary),
            onSelected: (_) => setState(() => _selectedIndex = i),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(_MonthSummary m) {
    return Container(
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
            'NET PROFIT | ${_label(m).toUpperCase()}',
            style: TextStyle(
              color: AppColors.onSurface.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _peso(m.netProfit),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatChip(label: 'Revenue', value: _peso(m.revenue)),
              const SizedBox(width: 12),
              _StatChip(label: 'COGS', value: _peso(m.cogs)),
              const SizedBox(width: 12),
              _StatChip(label: 'Expenses', value: _peso(m.expenses)),
              const SizedBox(width: 12),
              _StatChip(
                label: 'Margin',
                value: '${m.margin.toStringAsFixed(1)}%',
              ),
            ],
          ),
          if (m.unpaidAmount > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Unpaid: ${_peso(m.unpaidAmount)} (not counted in revenue)',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopProducts(_MonthSummary m) {
    final sorted = m.products.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TOP ORDERED',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 110,
          child: top.isEmpty
              ? const Center(child: Text('No ordered products this month.'))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: top.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) => _TopProductCard(
                    name: top[i].key,
                    count: top[i].value,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildMonthRow(int i) {
    final m = _history[i];
    final isSelected = i == _selectedIndex;
    final profitColor = m.netProfit >= 0 ? null : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() => _selectedIndex = i);
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _label(m),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Revenue ${_peso(m.revenue)}  •  ${m.totalOrders} orders',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _peso(m.netProfit),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: profitColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthSummary {
  final int year;
  final int month;

  double revenue = 0;
  double cogs = 0;
  double expenses = 0;
  double unpaidAmount = 0;
  int totalOrders = 0;
  int paidOrders = 0;
  int unpaidOrders = 0;
  final Map<String, int> products = {};

  _MonthSummary({required this.year, required this.month});

  double get netProfit => revenue - cogs - expenses;
  double get margin => revenue == 0 ? 0 : (netProfit / revenue) * 100;
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

class _TopProductCard extends StatelessWidget {
  final String name;
  final int count;

  const _TopProductCard({required this.name, required this.count});

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
            child: Icon(Icons.cookie_outlined, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$count',
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
