import 'package:flutter/material.dart';
import '../main.dart';
import '../models/expense.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/expense_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/user_header.dart';
import 'add_expense_dialog.dart';
import 'financial_summary_page.dart';
import 'order_board_page.dart';
import 'order_entry_form_page.dart';

class ExpensesLogPage extends StatefulWidget {
  const ExpensesLogPage({super.key});

  @override
  State<ExpensesLogPage> createState() => _ExpensesLogPageState();
}

class _ExpensesLogPageState extends State<ExpensesLogPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() => _isLoading = true);
    try {
      final rows = await supabase
          .from('expenses')
          .select()
          .order('date', ascending: false);

      final expenses = (rows as List)
          .map((row) => Expense.fromMap(row as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _expenses = expenses;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load expenses: $e')),
      );
    }
  }

  double _totalFor(String category) => _expenses
      .where((e) => e.category.toLowerCase() == category.toLowerCase())
      .fold(0.0, (sum, e) => sum + e.amount);

  double get _total => _expenses.fold(0.0, (sum, e) => sum + e.amount);

  Future<void> _openAddExpense() async {
    final expense = await showAddExpenseDialog(context);
    if (expense == null) return;

    try {
      await supabase.from('expenses').insert({
        ...expense.toMap(),
        'user_id': supabase.auth.currentUser!.id,
      });
      _loadExpenses();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save expense: $e')),
      );
    }
  }

  Future<void> _deleteExpense(Expense expense) async {
    try {
      await supabase.from('expenses').delete().eq('id', expense.id);
      if (!mounted) return;
      setState(() =>
          _expenses = _expenses.where((e) => e.id != expense.id).toList());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete expense: $e')),
      );
    }
  }

  void _navigateToTab(int index) {
    if (index == 2) return;
    late final Widget page;
    switch (index) {
      case 0:
        page = const OrderBoardPage();
        break;
      case 1:
        page = const OrderEntryFormPage();
        break;
      case 3:
        page = const FinancialSummaryPage();
        break;
      default:
        return;
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: UserHeader(
        name: 'LOUISE JACKSON',
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EXPENSES',
                  style: TextStyle(
                    fontFamily: AppTextStyles.logoFontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _openAddExpense,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Add',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Marketing',
                    value: _totalFor('Marketing').toStringAsFixed(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryCard(
                    title: 'Packaging',
                    value: _totalFor('Packaging').toStringAsFixed(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Delivery',
                    value: _totalFor('Delivery').toStringAsFixed(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryCard(
                    title: 'Total',
                    value: _total.toStringAsFixed(2),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _expenses.isEmpty
                      ? const Center(child: Text('No expenses yet'))
                      : RefreshIndicator(
                          onRefresh: _loadExpenses,
                          child: ListView.builder(
                            itemCount: _expenses.length,
                            itemBuilder: (context, index) {
                              final expense = _expenses[index];
                              return ExpenseCard(
                                expense: expense,
                                onDelete: () => _deleteExpense(expense),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 2, onTap: _navigateToTab),
    );
  }
}
