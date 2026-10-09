import 'package:flutter/material.dart';
import '../main.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/order_card.dart';
import '../widgets/user_header.dart';
import 'expenses_log_page.dart';
import 'financial_summary_page.dart';
import 'order_entry_form_page.dart';
import '../widgets/confirm_dialog.dart';

class OrderBoardPage extends StatefulWidget {
  const OrderBoardPage({super.key});

  @override
  State<OrderBoardPage> createState() => _OrderBoardPageState();
}

class _OrderBoardPageState extends State<OrderBoardPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final List<String> _categories = const [
    'All Orders',
    'Pick-up',
    'Meet-up',
    'Delivery',
  ];
  String _selectedCategory = 'All Orders';
  String _searchQuery = '';
  int _navIndex = 0;
  bool _isLoading = true;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    try {
      final rows = await supabase
          .from('orders')
          .select()
          .order('order_date', ascending: false);

      final orders = (rows as List)
          .map((row) => Order.fromMap(row as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load orders: $e')),
      );
    }
  }

  List<Order> get _filteredOrders {
    return _orders.where((order) {
      final matchesCategory = _selectedCategory == 'All Orders' ||
          order.fulfillmentType.label == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          order.customerName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _togglePaid(Order order) async {
    final newIsPaid = !order.isPaid;

    try {
      await supabase
          .from('orders')
          .update({'payment_status': newIsPaid ? 'Paid' : 'Not yet paid'})
          .eq('id', order.id);

      if (!mounted) return;
      setState(() {
        _orders = _orders
            .map((o) => o.id == order.id ? o.copyWith(isPaid: newIsPaid) : o)
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update payment status: $e')),
      );
    }
  }

    Future<void> _markChecked(Order order) async {
    try {
      await supabase
          .from('orders')
          .update({'is_checked': true}).eq('id', order.id);

      if (!mounted) return;
      setState(
          () => _orders = _orders.where((o) => o.id != order.id).toList());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          persist: false,
          duration: const Duration(seconds: 5),
          content: const Text('Order checked — moved to Previous Orders'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await supabase
                  .from('orders')
                  .update({'is_checked': false}).eq('id', order.id);
              _loadOrders();
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check order: $e')),
      );
    }
  }

  Future<void> _deleteOrder(Order order) async {
    final confirmed = await confirmDelete(
      context,
      title: 'Delete order?',
      message:
          "This permanently deletes ${order.customerName}'s order and can't be undone.",
    );
    if (!confirmed) return;

    try {
      await supabase.from('orders').delete().eq('id', order.id);
      if (!mounted) return;
      setState(
          () => _orders = _orders.where((o) => o.id != order.id).toList());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete order: $e')),
      );
    }
  }

  Future<void> _openOrderEntryForm({Order? existingOrder}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => OrderEntryFormPage(existingOrder: existingOrder),
      ),
    );
    if (saved == true) _loadOrders();
  }

  void _navigateToTab(int index) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
    if (index == 0) return;
    late final Widget page;
    switch (index) {
      case 1:
        page = const OrderEntryFormPage();
        break;
      case 2:
        page = const ExpensesLogPage();
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
        onProfileTap: () {},
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
                Text(
                  'ORDERS',
                  style: const TextStyle(
                    fontFamily: AppTextStyles.logoFontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openOrderEntryForm(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'New',
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
            AppSearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            CategoryChips(
              categories: _categories,
              selected: _selectedCategory,
              onSelected: (value) =>
                  setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredOrders.isEmpty
                      ? const Center(child: Text('No orders found'))
                      : RefreshIndicator(
                          onRefresh: _loadOrders,
                          child: ListView.builder(
                            itemCount: _filteredOrders.length,
                            itemBuilder: (context, index) {
                              final order = _filteredOrders[index];
                              return OrderCard(
                                order: order,
                                onTogglePaid: () => _togglePaid(order),
                                onToggleChecked: () => _markChecked(order),
                                onDelete: () => _deleteOrder(order),
                                onTap: () =>
                                    _openOrderEntryForm(existingOrder: order),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() => _navIndex = index);
          _navigateToTab(index);
        },
      ),
    );
  }
}
