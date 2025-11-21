import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/inventory_item_model.dart';
import '../../data/pen_model.dart';
import '../inventory/inventory_repository.dart';
import '../pens/pen_repository.dart';
import 'log_service.dart';

class AddLogScreen extends ConsumerStatefulWidget {
  const AddLogScreen({super.key});

  @override
  ConsumerState<AddLogScreen> createState() => _AddLogScreenState();
}

class _AddLogScreenState extends ConsumerState<AddLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mortalityController = TextEditingController(text: '0');
  final _feedGivenController = TextEditingController();
  final _eggsCollectedController = TextEditingController();

  Pen? _selectedPen;
  InventoryItem? _selectedFeedType;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _mortalityController.dispose();
    _feedGivenController.dispose();
    _eggsCollectedController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pensAsync = ref.watch(penListProvider);
    final inventoryAsync = ref.watch(inventoryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New Daily Log')),
      body: pensAsync.when(
        data: (pens) => inventoryAsync.when(
          data: (inventory) => _buildForm(context, pens, inventory),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    List<Pen> pens,
    List<InventoryItem> inventory,
  ) {
    if (pens.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No pens available. Create a pen first.'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go('/pens'),
              child: const Text('Go to Pens'),
            ),
          ],
        ),
      );
    }

    if (inventory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No feed types available. Add inventory first.'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go('/inventory'),
              child: const Text('Go to Inventory'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Pen>(
              decoration: const InputDecoration(
                labelText: 'Select Pen',
                border: OutlineInputBorder(),
              ),
              items: pens.map((pen) {
                return DropdownMenuItem(
                  value: pen,
                  child: Text('${pen.name} (${pen.breed})'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedPen = value),
              validator: (value) =>
                  value == null ? 'Please select a pen' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<InventoryItem>(
              decoration: const InputDecoration(
                labelText: 'Select Feed Type',
                border: OutlineInputBorder(),
              ),
              items: inventory.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    '${item.name} (${item.currentBalance.toStringAsFixed(1)} kg)',
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedFeedType = value),
              validator: (value) =>
                  value == null ? 'Please select feed type' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mortalityController,
              decoration: const InputDecoration(
                labelText: 'Mortality',
                hintText: '0',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mortality';
                }
                final mortality = int.tryParse(value);
                if (mortality == null || mortality < 0) {
                  return 'Mortality cannot be negative';
                }
                if (_selectedPen != null) {
                  final currentCount = ref.read(
                    currentBirdCountProvider(_selectedPen!.id),
                  );
                  if (mortality > currentCount) {
                    return 'Cannot record more dead birds than alive birds ($currentCount available)';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _feedGivenController,
              decoration: const InputDecoration(
                labelText: 'Feed Given (kg)',
                hintText: '0.0',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter feed amount';
                }
                final feed = double.tryParse(value);
                if (feed == null || feed < 0) {
                  return 'Feed cannot be negative';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _eggsCollectedController,
              decoration: const InputDecoration(
                labelText: 'Eggs Collected',
                hintText: '0',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter eggs collected';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat.yMMMd().format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saveLog,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Save Log'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveLog() async {
    if (!_formKey.currentState!.validate()) return;

    final mortality = int.parse(_mortalityController.text);
    final feedGiven = double.parse(_feedGivenController.text);
    final eggsCollected = int.parse(_eggsCollectedController.text);

    final service = ref.read(logServiceProvider);

    // Check feed availability
    final hasEnoughFeed = service.checkFeedAvailability(
      _selectedFeedType!.id,
      feedGiven,
    );

    if (!hasEnoughFeed) {
      final balance = service.getFeedBalance(_selectedFeedType!.id);
      final proceed = await _showLowStockWarning(context, balance, feedGiven);
      if (!proceed) return;
    }

    try {
      await service.saveLog(
        penId: _selectedPen!.id,
        date: _selectedDate,
        mortality: mortality,
        feedGiven: feedGiven,
        feedTypeId: _selectedFeedType!.id,
        eggsCollected: eggsCollected,
      );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Log saved successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<bool> _showLowStockWarning(
    BuildContext context,
    double balance,
    double requested,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Low Feed Warning'),
        content: Text(
          'Not enough feed in inventory.\n\n'
          'Available: ${balance.toStringAsFixed(1)} kg\n'
          'Requested: ${requested.toStringAsFixed(1)} kg\n\n'
          'Proceeding will result in negative stock. Continue anyway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Proceed Anyway'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
