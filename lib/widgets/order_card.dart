import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  final VoidCallback? onTogglePaid;
  final VoidCallback? onToggleChecked;
  final VoidCallback? onDelete;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onTogglePaid,
    this.onToggleChecked,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
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
                          GestureDetector(
                            onTap: onTogglePaid,
                            child: _StatusBadge(isPaid: order.isPaid),
                          ),
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
                      if (order.address != null &&
                          order.address!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          order.address!,
                          style: TextStyle(
                            color: AppColors.onSurface.withOpacity(0.5),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onToggleChecked != null)
                          Tooltip(
                            message: order.isChecked
                                ? 'Move back to Orders'
                                : 'Mark as done',
                            child: InkWell(
                              onTap: onToggleChecked,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  order.isChecked
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  size: 22,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        if (onDelete != null) ...[
                          const SizedBox(width: 6),
                          Tooltip(
                            message: 'Delete order',
                            child: InkWell(
                              onTap: onDelete,
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(Icons.delete_outline,
                                    size: 22, color: Colors.redAccent),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
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