import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/category_chips.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/user_header.dart';
import 'expenses_log_page.dart';
import 'financial_summary_page.dart';
import 'order_board_page.dart';

class _ProductCatalogItem {
  final String name;
  final double price;
  final double cost;
  const _ProductCatalogItem(this.name, this.price, this.cost);
}

class OrderEntryFormPage extends StatefulWidget {
  /// Pass an existing order to edit it; leave null to create a new order.
  final Order? existingOrder;

  const OrderEntryFormPage({super.key, this.existingOrder});

  @override
  State<OrderEntryFormPage> createState() => _OrderEntryFormPageState();
}

class _OrderEntryFormPageState extends State<OrderEntryFormPage> {
  static const _catalog = [
    _ProductCatalogItem('Pistachio', 140, 70),
    _ProductCatalogItem('Matcha', 110, 55),
    _ProductCatalogItem('Biscoff', 120, 60),
  ];

  final _customerController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  String _fulfillment = 'Pick-up';
  String _paymentMode = 'Cash';
  final Map<String, int> _quantities = {
    for (final item in _catalog) item.name: 0,
  };

  @override
  void initState() {
    super.initState();
    final order = widget.existingOrder;
    if (order != null) {
      _customerController.text = order.customerName;
      _dateController.text = _formatDate(order.deliveryDate);
      _fulfillment = order.fulfillmentType.label;
      _paymentMode = order.paymentMode.label;
      _noteController.text = order.note ?? '';
      for (final item in order.items) {
        _quantities[item.product] = item.quantity;
      }
    }
  }

  @override
  void dispose() {
    _customerController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) => '${date.month}/${date.day}/${date.year}';

  double get _total {
    var sum = 0.0;
    for (final item in _catalog) {
      sum += (_quantities[item.name] ?? 0) * item.price;
    }
    return sum;
  }

  double get _cogs {
    var sum = 0.0;
    for (final item in _catalog) {
      sum += (_quantities[item.name] ?? 0) * item.cost;
    }
    return sum;
  }

  double get _profit => _total - _cogs;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dateController.text = _formatDate(picked));
    }
  }

  void _saveOrder() {
    if (_customerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a customer name')),
      );
      return;
    }
    if (_total == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one item')),
      );
      return;
    }

    // TODO: replace with a real Supabase insert/update once your table is
    // live, e.g.:
    // await Supabase.instance.client.from('orders').insert({...});

    Navigator.of(context).pop();
  }

  void _navigateToTab(int index) {
    if (index == 1) return; // already on this tab
    late final Widget page;
    switch (index) {
      case 0:
        page = const OrderBoardPage();
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
    final isEditing = widget.existingOrder != null;

    return Scaffold(
      appBar: const UserHeader(name: 'LOUISE JACKSON'),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'EDIT ORDER' : 'NEW ORDER',
              style: const TextStyle(
                fontFamily: AppTextStyles.logoFontFamily,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Customer Name',
              controller: _customerController,
              hintText: 'e.g. Juan Dela Cruz',
            ),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: AppTextField(
                  label: 'Delivery Date',
                  controller: _dateController,
                  hintText: 'mm/dd/yyyy',
                  suffixIcon:
                      const Icon(Icons.calendar_today_outlined, size: 18),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            CategoryChips(
              categories: const ['Pick-up', 'Delivery', 'Meet-up'],
              selected: _fulfillment,
              onSelected: (value) => setState(() => _fulfillment = value),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  for (final item in _catalog)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            item.price.toStringAsFixed(2),
                            style: TextStyle(
                              color: AppColors.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          QuantitySelector(
                            quantity: _quantities[item.name] ?? 0,
                            onIncrement: () => setState(() {
                              _quantities[item.name] =
                                  (_quantities[item.name] ?? 0) + 1;
                            }),
                            onDecrement: () => setState(() {
                              final current = _quantities[item.name] ?? 0;
                              if (current > 0) {
                                _quantities[item.name] = current - 1;
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(label: 'TOTAL', value: _total, bold: true),
            _SummaryRow(label: 'COST OF GOODS', value: _cogs),
            _SummaryRow(label: 'PROFIT', value: _profit),
            const SizedBox(height: AppSpacing.md),
            CategoryChips(
              categories: const ['Cash', 'Gcash', 'Bank Transfer'],
              selected: _paymentMode,
              onSelected: (value) => setState(() => _paymentMode = value),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _noteController,
              hintText: 'Note',
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  isEditing ? 'Update Order' : 'Add Order',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 1, onTap: _navigateToTab),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: AppColors.onSurface.withOpacity(bold ? 1 : 0.7),
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
