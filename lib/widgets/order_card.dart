import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            order.customerName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(isPaid: order.isPaid),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.itemsSummary,
                      style: TextStyle(
                        color: AppColors.onSurface.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'For ${order.fulfillmentType.label}',
                      style: TextStyle(
                        color: AppColors.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PaymentModeBadge(mode: order.paymentMode),
                  const SizedBox(height: 8),
                  Text(
                    order.total.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isPaid;
  const _StatusBadge({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green.shade600 : Colors.red.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPaid ? 'Paid' : 'Not yet paid',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}

class _PaymentModeBadge extends StatelessWidget {
  final PaymentMode mode;
  const _PaymentModeBadge({required this.mode});

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (mode) {
      case PaymentMode.gcash:
        color = Colors.blue.shade700;
        break;
      case PaymentMode.cash:
        color = Colors.brown.shade400;
        break;
      case PaymentMode.bankTransfer:
        color = Colors.teal.shade600;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        mode.label,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
