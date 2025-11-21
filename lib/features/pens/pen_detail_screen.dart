import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/pen_model.dart';
import '../logs/log_service.dart';
import 'pen_repository.dart';

class PenDetailScreen extends ConsumerWidget {
  final String penId;

  const PenDetailScreen({required this.penId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final penAsync = ref.watch(penProvider(penId));

    return Scaffold(
      appBar: AppBar(title: const Text('Pen Details')),
      body: penAsync.when(
        data: (pen) {
          if (pen == null) {
            return const Center(child: Text('Pen not found'));
          }
          return _PenDetailContent(pen: pen);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _PenDetailContent extends ConsumerWidget {
  final Pen pen;

  const _PenDetailContent({required this.pen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCount = ref.watch(currentBirdCountProvider(pen.id));
    final mortalityRate = pen.initialCount > 0
        ? ((pen.initialCount - currentCount) / pen.initialCount * 100)
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(context),
          const SizedBox(height: 24),
          Text(
            'Performance Stats',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildStatsGrid(context, currentCount, mortalityRate),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pen.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(pen.breed),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Started: ${DateFormat.yMMMd().format(pen.dateStarted)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Initial Count: ${pen.initialCount} Birds',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    int currentFlockSize,
    double mortalityRate,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          context,
          'Current Flock',
          '$currentFlockSize',
          Icons.pets,
          Colors.blue,
          subtitle: 'Birds Alive',
        ),
        _buildStatCard(
          context,
          'Mortality Rate',
          '${mortalityRate.toStringAsFixed(1)}%',
          Icons.warning_amber,
          mortalityRate > 5 ? Colors.red : Colors.green,
          subtitle: 'Target: <5%',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
