import 'package:flutter/material.dart';
import '../main.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/order_card.dart';
import 'order_entry_form_page.dart';

enum _GroupBy { month, date }

class PreviousOrdersPage extends StatefulWidget {
  const PreviousOrdersPage({super.key});

  @override
  State<PreviousOrdersPage> createState() => _PreviousOrdersPageState();
}

class _PreviousOrdersPageState extends State<PreviousOrdersPage> {
  _GroupBy _groupBy = _GroupBy.month;
  bool _isLoading = true;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final rows = await supabase
          .from('orders')
          .select()
          .eq('is_checked', true)
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
        SnackBar(content: Text('Failed to load previous orders: $e')),
      );
    }
  }

  Map<String, List<Order>> get _grouped {
    final map = <String, List<Order>>{};
    for (final order in _orders) {
      final key = _groupBy == _GroupBy.month
          ? _monthLabel(order.deliveryDate)
          : _dateLabel(order.deliveryDate);
      map.putIfAbsent(key, () => []).add(order);
    }
    return map;
  }

  String _monthLabel(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _dateLabel(DateTime date) => '${date.month}/${date.day}/${date.year}';

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

  Future<void> _moveBackToOrders(Order order) async {
    try {
      await supabase
          .from('orders')
          .update({'is_checked': false}).eq('id', order.id);

      if (!mounted) return;
      setState(
          () => _orders = _orders.where((o) => o.id != order.id).toList());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Moved back to Orders')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to move order: $e')),
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

  Future<void> _editOrder(Order order) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => OrderEntryFormPage(existingOrder: order),
      ),
    );
    if (saved == true) _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final sectionKeys = grouped.keys.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Previous Orders'),
      ),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _ToggleButton(
                    label: 'By Month',
                    selected: _groupBy == _GroupBy.month,
                    onTap: () => setState(() => _groupBy = _GroupBy.month),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ToggleButton(
                    label: 'By Date',
                    selected: _groupBy == _GroupBy.date,
                    onTap: () => setState(() => _groupBy = _GroupBy.date),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _orders.isEmpty
                      ? const Center(
                          child: Text(
                            'No checked orders yet.\nCheck an order on the Orders screen to move it here.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadOrders,
                          child: ListView.builder(
                            itemCount: sectionKeys.length,
                            itemBuilder: (context, sectionIndex) {
                              final key = sectionKeys[sectionIndex];
                              final orders = grouped[key]!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  for (final order in orders)
                                    OrderCard(
                                      order: order,
                                      onTogglePaid: () => _togglePaid(order),
                                      onToggleChecked: () =>
                                          _moveBackToOrders(order),
                                      onDelete: () => _deleteOrder(order),
                                      onTap: () => _editOrder(order),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}