import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/inventory_item_model.dart';
import 'inventory_repository.dart';
import 'widgets/add_inventory_dialog.dart';
import 'widgets/stock_update_dialog.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryList = ref.watch(inventoryListProvider);

    return inventoryList.when(
      data: (items) {
        final isEmpty = items.isEmpty;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Inventory'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilledButton.icon(
                  onPressed: () => _showAddDialog(context, ref),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Feed'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: isEmpty
              ? _buildEmptyState(context, ref)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _InventoryItemCard(item: item);
                  },
                ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Inventory'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilledButton.icon(
                onPressed: () => _showAddDialog(context, ref),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Feed'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Inventory'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilledButton.icon(
                onPressed: () => _showAddDialog(context, ref),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Feed'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No feed types found.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _showAddDialog(context, ref),
            child: const Text('Add your first record'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddInventoryDialog(),
    );

    if (result != null) {
      await ref
          .read(inventoryRepositoryProvider)
          .createItem(
            name: result['name'],
            currentBalance: result['balance'],
            lowStockThreshold: result['threshold'],
          );
    }
  }
}

class _InventoryItemCard extends ConsumerWidget {
  final InventoryItem item;

  const _InventoryItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLowStock = item.currentBalance < item.lowStockThreshold;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isLowStock
              ? Colors.red.shade100
              : Colors.green.shade100,
          child: Icon(
            Icons.grass,
            color: isLowStock ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.currentBalance.toStringAsFixed(1)} kg available'),
            if (isLowStock)
              Text(
                'Low Stock (Threshold: ${item.lowStockThreshold.toStringAsFixed(1)} kg)',
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: Theme.of(context).primaryColor,
          onPressed: () => _showStockUpdateDialog(context, ref, item),
        ),
        onTap: () => _showStockUpdateDialog(context, ref, item),
      ),
    );
  }

  Future<void> _showStockUpdateDialog(
    BuildContext context,
    WidgetRef ref,
    InventoryItem item,
  ) async {
    final amount = await showDialog<double>(
      context: context,
      builder: (context) => StockUpdateDialog(
        itemName: item.name,
        currentStock: item.currentBalance,
      ),
    );

    if (amount != null) {
      await ref.read(inventoryRepositoryProvider).addStock(item.id, amount);
    }
  }
}
