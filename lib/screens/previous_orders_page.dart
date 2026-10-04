import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
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
  List<Order> _orders = _mockOrders();

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
      'July', 'August', 'September', 'October', 'November', 'December', // ignore: lines_longer_than_80_chars
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _dateLabel(DateTime date) => '${date.month}/${date.day}/${date.year}';

  void _togglePaid(Order order) {
    setState(() {
      _orders = _orders
          .map((o) => o.id == order.id ? o.copyWith(isPaid: !o.isPaid) : o)
          .toList();
    });
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
      backgroundColor: AppColors.background,
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
              child: ListView.builder(
                itemCount: sectionKeys.length,
                itemBuilder: (context, sectionIndex) {
                  final key = sectionKeys[sectionIndex];
                  final orders = grouped[key]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    OrderEntryFormPage(existingOrder: order),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder data spanning a few months, until this reads from Supabase.
  static List<Order> _mockOrders() {
    return [
      Order(
        id: '1',
        customerName: 'Loven Victoria',
        deliveryDate: DateTime(2026, 7, 12),
        items: const [
          OrderItem(product: 'Pistachio', quantity: 2, unitPrice: 140),
        ],
        fulfillmentType: FulfillmentType.pickUp,
        paymentMode: PaymentMode.gcash,
        isPaid: true,
        cogs: 140,
      ),
      Order(
        id: '2',
        customerName: 'Joy Sarmiento',
        deliveryDate: DateTime(2026, 6, 20),
        items: const [
          OrderItem(product: 'Biscoff', quantity: 1, unitPrice: 120),
        ],
        fulfillmentType: FulfillmentType.delivery,
        paymentMode: PaymentMode.cash,
        isPaid: true,
        cogs: 60,
        address: '123 Mango St., Angeles City',
      ),
      Order(
        id: '3',
        customerName: 'Yohan Dy',
        deliveryDate: DateTime(2026, 6, 5),
        items: const [
          OrderItem(product: 'Matcha', quantity: 2, unitPrice: 110),
        ],
        fulfillmentType: FulfillmentType.pickUp,
        paymentMode: PaymentMode.gcash,
        isPaid: false,
        cogs: 110,
      ),
    ];
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
