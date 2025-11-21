import 'package:flutter/material.dart';

import '../../../data/inventory_item_model.dart';

class FeedAlertCard extends StatelessWidget {
  final List<InventoryItem> lowStockItems;

  const FeedAlertCard({required this.lowStockItems, super.key});

  @override
  Widget build(BuildContext context) {
    if (lowStockItems.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.red.shade50,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.red.shade700, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Low Feed Warning',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...lowStockItems.map(
                    (item) => Text(
                      '${item.name}: ${item.currentBalance.toStringAsFixed(1)} kg remaining',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
