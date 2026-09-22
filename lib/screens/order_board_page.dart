import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/order_card.dart';
import '../widgets/user_header.dart';

class OrderBoardPage extends StatefulWidget {
  const OrderBoardPage({super.key});

  @override
  State<OrderBoardPage> createState() => _OrderBoardPageState();
}

class _OrderBoardPageState extends State<OrderBoardPage> {
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

    // TODO: replace with a real Supabase query once your table is live, e.g.:
    // final rows = await Supabase.instance.client
    //     .from('orders')
    //     .select()
    //     .order('order_date', ascending: false);
    // final orders = rows.map((row) => Order.fromMap(row)).toList();
    await Future.delayed(const Duration(milliseconds: 400));
    final orders = _mockOrders();

    if (!mounted) return;
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserHeader(
        name: 'LJ_ORAYE',
        role: 'Co-owner',
        onMenuTap: () {
          // TODO: open the navigation/settings drawer
        },
        onProfileTap: () {
          // TODO: open profile/account settings
        },
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ORDERS', style: AppTextStyles.heading()),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigator.push to the Order Entry Form
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New'),
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
                                onTap: () {
                                  // TODO: open the Order Entry Form in edit mode
                                },
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
          // TODO: navigate to Dashboard / New Order / Expenses / Financials
        },
      ),
    );
  }

  // Placeholder data so this screen is usable before Supabase is wired up.
  List<Order> _mockOrders() {
    return [
      Order(
        id: '1',
        customerName: 'Loven Victoria',
        deliveryDate: DateTime.now(),
        items: const [
          OrderItem(product: 'Pistachio', quantity: 2, unitPrice: 140),
          OrderItem(product: 'Matcha', quantity: 1, unitPrice: 110),
        ],
        fulfillmentType: FulfillmentType.pickUp,
        paymentMode: PaymentMode.gcash,
        isPaid: false,
        cogs: 200,
      ),
      Order(
        id: '2',
        customerName: 'Joy Sarmiento',
        deliveryDate: DateTime.now(),
        items: const [
          OrderItem(product: 'Pistachio', quantity: 1, unitPrice: 140),
          OrderItem(product: 'Biscoff', quantity: 1, unitPrice: 120),
        ],
        fulfillmentType: FulfillmentType.delivery,
        paymentMode: PaymentMode.cash,
        isPaid: true,
        cogs: 150,
      ),
      Order(
        id: '3',
        customerName: 'Yohan Dy',
        deliveryDate: DateTime.now(),
        items: const [
          OrderItem(product: 'Biscoff', quantity: 2, unitPrice: 110),
        ],
        fulfillmentType: FulfillmentType.pickUp,
        paymentMode: PaymentMode.gcash,
        isPaid: false,
        cogs: 130,
      ),
    ];
  }
}
