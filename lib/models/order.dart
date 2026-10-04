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

  /// Delivery or meet-up address. Only meaningful when fulfillmentType is
  /// delivery or meetUp — null/empty for pick-up orders.
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

  /// Returns a copy of this order with the given fields replaced. Used for
  /// local, in-memory updates (like toggling paid status) before this is
  /// backed by a real database.
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

  /// Maps a row from your Supabase `orders` table to an [Order].
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      customerName: map['customer_name'] as String,
      deliveryDate: DateTime.parse(map['order_date'] as String),
      items: const [], // TODO: decide how line items are stored, then parse them here
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
