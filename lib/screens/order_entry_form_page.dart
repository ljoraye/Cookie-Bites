import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/category_chips.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_header.dart';
import 'expenses_log_page.dart';
import 'financial_summary_page.dart';
import 'order_board_page.dart';

class OrderEntryFormPage extends StatefulWidget {
  /// Pass an existing order to edit it; leave null to create a new order.
  final Order? existingOrder;

  const OrderEntryFormPage({super.key, this.existingOrder});

  @override
  State<OrderEntryFormPage> createState() => _OrderEntryFormPageState();
}

class _OrderEntryFormPageState extends State<OrderEntryFormPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _customerController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();
  final _addressController = TextEditingController();

  String _fulfillment = 'Pick-up';
  String _paymentMode = 'Cash';

  /// Quantities keyed by Product.id, so renaming a product never breaks the
  /// mapping (unlike keying by name).
  final Map<String, int> _quantities = {
    for (final product in ProductCatalog.items) product.id: 0,
  };

  bool get _needsAddress => _fulfillment != 'Pick-up';

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
      _addressController.text = order.address ?? '';
      for (final item in order.items) {
        final match = ProductCatalog.items
            .where((p) => p.name == item.product)
            .toList();
        if (match.isNotEmpty) {
          _quantities[match.first.id] = item.quantity;
        }
      }
    }
  }

  @override
  void dispose() {
    _customerController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) =>
      '${date.month}/${date.day}/${date.year}';

  double get _total {
    var sum = 0.0;
    for (final product in ProductCatalog.items) {
      sum += (_quantities[product.id] ?? 0) * product.sellingPrice;
    }
    return sum;
  }

  double get _cogs {
    var sum = 0.0;
    for (final product in ProductCatalog.items) {
      sum += (_quantities[product.id] ?? 0) * product.costOfGoods;
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
    if (_needsAddress && _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter a${_fulfillment == 'Delivery' ? ' delivery' : ' meet-up'} address',
          ),
        ),
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
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: UserHeader(
        name: 'LOUISE JACKSON',
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
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
            // Address field only appears for Delivery or Meet-up — hidden
            // entirely for Pick-up since there's nothing to deliver to.
            if (_needsAddress) ...[
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: _fulfillment == 'Delivery'
                    ? 'Delivery Address'
                    : 'Meet-up Location',
                controller: _addressController,
                hintText: _fulfillment == 'Delivery'
                    ? 'e.g. 123 Mango St., Angeles City'
                    : 'e.g. SM Clark, main entrance',
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  for (final product in ProductCatalog.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            product.sellingPrice.toStringAsFixed(2),
                            style: TextStyle(
                              color: AppColors.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          QuantitySelector(
                            quantity: _quantities[product.id] ?? 0,
                            onIncrement: () => setState(() {
                              _quantities[product.id] =
                                  (_quantities[product.id] ?? 0) + 1;
                            }),
                            onDecrement: () => setState(() {
                              final current = _quantities[product.id] ?? 0;
                              if (current > 0) {
                                _quantities[product.id] = current - 1;
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  if (ProductCatalog.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        'No products yet — add one from the hamburger menu '
                        '> Manage Products.',
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
