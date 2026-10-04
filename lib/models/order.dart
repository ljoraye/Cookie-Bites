class OrderItem {
  final String product;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;

  String get label => '$quantity $product';

  Map<String, dynamic> toMap() => {
        'product': product,
        'quantity': quantity,
        'unit_price': unitPrice,
      };

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: map['product'] as String,
      quantity: map['quantity'] as int,
      unitPrice: (map['unit_price'] as num).toDouble(),
    );
  }
}

enum FulfillmentType { pickUp, delivery, meetUp }

enum PaymentMode { cash, gcash, bankTransfer }

extension FulfillmentTypeLabel on FulfillmentType {
  String get label {
    switch (this) {
      case FulfillmentType.pickUp:
        return 'Pick-up';
      case FulfillmentType.delivery:
        return 'Delivery';
      case FulfillmentType.meetUp:
        return 'Meet-up';
    }
  }
}

extension PaymentModeLabel on PaymentMode {
  String get label {
    switch (this) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.gcash:
        return 'Gcash';
      case PaymentMode.bankTransfer:
        return 'Bank Transfer';
    }
  }
}

class Order {
  final String id;
  final String customerName;
  final DateTime deliveryDate;
  final List<OrderItem> items;
  final FulfillmentType fulfillmentType;
  final PaymentMode paymentMode;
  final bool isPaid;
  final double cogs;
  final String? note;
  final String? address;

  const Order({
    required this.id,
    required this.customerName,
    required this.deliveryDate,
    required this.items,
    required this.fulfillmentType,
    required this.paymentMode,
    required this.isPaid,
    required this.cogs,
    this.note,
    this.address,
  });

  double get total => items.fold(0, (sum, item) => sum + item.lineTotal);

  double get profit => total - cogs;

  String get itemsSummary => items.map((i) => i.label).join(' | ');

  Order copyWith({
    String? id,
    String? customerName,
    DateTime? deliveryDate,
    List<OrderItem>? items,
    FulfillmentType? fulfillmentType,
    PaymentMode? paymentMode,
    bool? isPaid,
    double? cogs,
    String? note,
    String? address,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      items: items ?? this.items,
      fulfillmentType: fulfillmentType ?? this.fulfillmentType,
      paymentMode: paymentMode ?? this.paymentMode,
      isPaid: isPaid ?? this.isPaid,
      cogs: cogs ?? this.cogs,
      note: note ?? this.note,
      address: address ?? this.address,
    );
  }

  /// Converts this order to a map ready for Supabase insert/update.
  /// Deliberately omits `id` and `user_id` — the caller adds `user_id` (it
  /// knows the current session), and `id` is server-generated on insert /
  /// already known on update (used in `.eq('id', ...)` instead).
  Map<String, dynamic> toMap() {
    return {
      'customer_name': customerName,
      'items': items.map((i) => i.toMap()).toList(),
      'fulfillment_type': fulfillmentType.label,
      'payment_mode': paymentMode.label,
      'payment_status': isPaid ? 'Paid' : 'Not yet paid',
      'total_price': total,
      'cogs': cogs,
      'order_date': deliveryDate.toIso8601String(),
      'adjustment_note': note,
      'address': address,
    };
  }

  /// Maps a row from your Supabase `orders` table to an [Order].
  factory Order.fromMap(Map<String, dynamic> map) {
    final rawItems = (map['items'] as List<dynamic>? ?? [])
        .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
        .toList();

    return Order(
      id: map['id'] as String,
      customerName: map['customer_name'] as String,
      deliveryDate: DateTime.parse(map['order_date'] as String),
      items: rawItems,
      fulfillmentType: FulfillmentType.values.firstWhere(
        (f) => f.label == map['fulfillment_type'],
        orElse: () => FulfillmentType.pickUp,
      ),
      paymentMode: PaymentMode.values.firstWhere(
        (p) => p.label == map['payment_mode'],
        orElse: () => PaymentMode.cash,
      ),
      isPaid: (map['payment_status'] as String?) == 'Paid',
      cogs: (map['cogs'] as num?)?.toDouble() ?? 0,
      note: map['adjustment_note'] as String?,
      address: map['address'] as String?,
    );
  }
}
