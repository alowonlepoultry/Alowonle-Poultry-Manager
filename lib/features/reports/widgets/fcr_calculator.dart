import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FcrCalculator extends StatefulWidget {
  const FcrCalculator({super.key});

  @override
  State<FcrCalculator> createState() => _FcrCalculatorState();
}

class _FcrCalculatorState extends State<FcrCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _feedConsumedController = TextEditingController();
  final _weightProducedController = TextEditingController();

  double? _fcrResult;

  @override
  void dispose() {
    _feedConsumedController.dispose();
    _weightProducedController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final feedConsumed = double.parse(_feedConsumedController.text);
      final weightProduced = double.parse(_weightProducedController.text);

      setState(() {
        _fcrResult = feedConsumed / weightProduced;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'FCR Calculator',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feedConsumedController,
                decoration: const InputDecoration(
                  labelText: 'Total Feed Consumed (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter feed consumed'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightProducedController,
                decoration: const InputDecoration(
                  labelText: 'Total Weight Produced (kg)',
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
                    return 'Please enter weight produced';
                  }
                  if (double.tryParse(value) == 0) {
                    return 'Weight cannot be zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _calculate,
                child: const Text('Calculate FCR'),
              ),
              if (_fcrResult != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'FCR Result',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _fcrResult!.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lower is better. Standard is 1.5 - 1.7 for Broilers.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
