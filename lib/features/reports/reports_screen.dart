import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'pdf_report_generator.dart';
import 'report_service.dart';
import 'widgets/fcr_calculator.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  bool _isGenerating = false;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);

    try {
      final service = ref.read(reportServiceProvider);
      final data = service.getReportData(_startDate, _endDate);

      await PdfReportGenerator.generateAndPrint(data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Tools')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Calculators',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const FcrCalculator(),
            const SizedBox(height: 32),
            Text(
              'Reports',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildWeeklyReportSection(),
            const SizedBox(height: 32),
            Text(
              'About',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPrivacyPolicySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicySection() {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.privacy_tip),
        title: const Text('Privacy Policy'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Privacy Policy'),
              content: const SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Safehand Poultry Manager is an offline-first application designed to help you manage your farm efficiently.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Data Collection:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'We do not collect, store, or transmit any of your personal data, farm records, or usage statistics to external servers.',
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Data Storage:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'All your data is stored locally on your device. You are fully responsible for your data backup.',
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Permissions:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'The app may require access to storage to save PDF reports generated by you.',
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyReportSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Weekly Report (PDF)',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectStartDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat.yMMMd().format(_startDate)),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectEndDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat.yMMMd().format(_endDate)),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isGenerating ? null : _generateReport,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf),
              label: Text(
                _isGenerating ? 'Generating...' : 'Generate PDF Report',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
