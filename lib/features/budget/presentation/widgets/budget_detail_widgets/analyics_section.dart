import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/presentation/cubit/currency_cubit.dart';
import '../../../../../core/utils/currency_formatter.dart';
import '../../../../expenses/domain/entities/expense.dart';
import '../../../domain/entities/budget.dart';

class AnalyticsSection extends StatelessWidget {
  final Budget budget;
  final List<Expense> expenses;
  final double spent;

  const AnalyticsSection({
    required this.budget,
    required this.expenses,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate daily spending
    final daysPassed = DateTime.now().difference(budget.startDate).inDays + 1;
    final totalDays = budget.endDate.difference(budget.startDate).inDays + 1;
    final double avgDailySpending = daysPassed > 0 ? spent / daysPassed : 0;
    final projectedSpending = avgDailySpending * totalDays;

    // Group expenses by day
    final Map<DateTime, double> dailySpending = {};
    for (final expense in expenses) {
      final date = DateTime(
        expense.createdAt.year,
        expense.createdAt.month,
        expense.createdAt.day,
      );
      dailySpending[date] = (dailySpending[date] ?? 0) + expense.amount;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: BlocBuilder<CurrencyCubit, AppCurrency>(
                  builder: (context, currency) => _StatCard(
                    label: 'Daily Avg',
                    value: formatCurrency(avgDailySpending, currency),
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Transactions',
                  value: expenses.length.toString(),
                  icon: Icons.receipt,
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Days Passed',
                  value: '$daysPassed / $totalDays',
                  icon: Icons.schedule,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BlocBuilder<CurrencyCubit, AppCurrency>(
                  builder: (context, currency) => _StatCard(
                    label: 'Projected',
                    value: formatCurrency(projectedSpending, currency),
                    icon: Icons.trending_up,
                    color: projectedSpending > budget.amount
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),

          if (dailySpending.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Spending Trend',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _SpendingChart(dailySpending: dailySpending),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SpendingChart extends StatelessWidget {
  final Map<DateTime, double> dailySpending;

  const _SpendingChart({required this.dailySpending});

  @override
  Widget build(BuildContext context) {
    final sortedDates = dailySpending.keys.toList()..sort();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final currency = context.read<CurrencyCubit>().state;
                final symbol = currencySymbol(currency);
                return Text(
                  '$symbol${(value / 1000).toStringAsFixed(0)}k',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedDates.length)
                  return const SizedBox();
                return Text(
                  DateFormat('MM/dd').format(sortedDates[value.toInt()]),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: sortedDates.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), dailySpending[e.value]!);
            }).toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
