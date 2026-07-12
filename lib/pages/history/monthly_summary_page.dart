import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../providers/meal_providers.dart';
import '../../l10n/app_localizations.dart';

class MonthlySummaryPage extends ConsumerStatefulWidget {
  const MonthlySummaryPage({super.key});

  @override
  ConsumerState<MonthlySummaryPage> createState() => _MonthlySummaryPageState();
}

class _MonthlySummaryPageState extends ConsumerState<MonthlySummaryPage> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(monthlySummaryProvider(_currentMonth));

    return Scaffold(
      appBar: AppBar(
        title: Text('📊 ${l10n.monthlySummary}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            onPressed: () {
              setState(
                () =>
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month - 1,
                    ),
              );
            },
          ),
          Center(child: Text(DateFormat('MMM yyyy').format(_currentMonth))),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              setState(
                () =>
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month + 1,
                    ),
              );
            },
          ),
        ],
      ),
      body: summaryAsync.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(child: Text(l10n.noHistoryThisMonth));
          }

          // เตรียมข้อมูลจุดกราฟของโปรตีน
          final spots =
              data.asMap().entries.map((e) {
                final idx = e.key.toDouble();
                final protein = (e.value['total_protein_g'] as num).toDouble();
                return FlSpot(idx, protein);
              }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.proteinIntakeGraph,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < data.length) {
                                final dateStr =
                                    data[value.toInt()]['log_date'] as String;
                                final day = DateTime.parse(dateStr).day;
                                return Text(
                                  '$day',
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.monthlySummary,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildStatRow(
                          l10n.avgProtein,
                          _calculateAvg(data, 'total_protein_g'),
                          'g',
                          Colors.blue,
                        ),
                        _buildStatRow(
                          l10n.avgSodium,
                          _calculateAvg(data, 'total_sodium_mg'),
                          'mg',
                          Colors.orange,
                        ),
                        _buildStatRow(
                          l10n.avgPotassium,
                          _calculateAvg(data, 'total_potassium_mg'),
                          'mg',
                          Colors.purple,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('${l10n.error}: $err')),
      ),
    );
  }

  double _calculateAvg(List<dynamic> data, String key) {
    if (data.isEmpty) return 0;
    double sum = 0;
    for (var row in data) {
      sum += (row[key] as num).toDouble();
    }
    return sum / data.length;
  }

  Widget _buildStatRow(String label, double value, String unit, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${value.toStringAsFixed(1)} $unit',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
