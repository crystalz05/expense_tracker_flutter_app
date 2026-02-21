import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/cubit/currency_cubit.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/entities/category_spending.dart';
import '../../domain/entities/monthly_comparison.dart';
import '../../domain/entities/monthly_spending.dart';
import '../../domain/entities/spending_insight.dart';
import '../../domain/entities/spending_trend.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../../../expenses/presentation/misc/formatter.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  void _loadAnalytics() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    context.read<AnalyticsBloc>().add(
      LoadAnalyticsSummaryEvent(startDate: startOfMonth, endDate: endOfMonth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadAnalytics();
          },
          child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
            builder: (context, state) {
              if (state is AnalyticsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AnalyticsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading analytics',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _loadAnalytics,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is AnalyticsSummaryLoaded) {
                return _buildAnalyticsContent(context, state.summary);
              }

              return const Center(child: Text('No data available'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsContent(
    BuildContext context,
    AnalyticsSummary summary,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Analytics',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Your spending insights',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),

          // Insights Section
          if (summary.insights.isNotEmpty) ...[
            _SectionHeader(title: 'Insights', icon: Icons.lightbulb_outline),
            const SizedBox(height: 12),
            ...summary.insights.map(
              (insight) => _InsightCard(insight: insight),
            ),
            const SizedBox(height: 24),
          ],

          // Category Spending Chart
          _SectionHeader(title: 'Category Breakdown', icon: Icons.pie_chart),
          const SizedBox(height: 12),
          _CategoryPieChart(categories: summary.categoryBreakdown),
          const SizedBox(height: 24),

          // Category List
          _CategoryList(categories: summary.categoryBreakdown),
          const SizedBox(height: 24),

          // Monthly Comparison
          if (summary.monthComparison != null) ...[
            _SectionHeader(
              title: 'Month Comparison',
              icon: Icons.compare_arrows,
            ),
            const SizedBox(height: 12),
            _MonthComparisonCard(comparison: summary.monthComparison!),
            const SizedBox(height: 24),
          ],

          // Spending Trend
          _SectionHeader(title: 'Spending Trend', icon: Icons.trending_up),
          const SizedBox(height: 12),
          _SpendingTrendChart(trend: summary.trend),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final SpendingInsight insight;

  const _InsightCard({required this.insight});

  Color _getSeverityColor(BuildContext context, InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.critical:
        return Colors.red;
      case InsightSeverity.warning:
        return Colors.orange;
      case InsightSeverity.info:
        return Colors.blue;
    }
  }

  IconData _getSeverityIcon(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.critical:
        return Icons.error;
      case InsightSeverity.warning:
        return Icons.warning;
      case InsightSeverity.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSeverityColor(context, insight.severity);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getSeverityIcon(insight.severity),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insight.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
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

class _CategoryPieChart extends StatelessWidget {
  final List<CategorySpending> categories;

  const _CategoryPieChart({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Card(
        child: Container(
          height: 250,
          alignment: Alignment.center,
          child: Text(
            'No spending data',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return PieChartSectionData(
                  value: category.amount,
                  title: '${category.percentage.toStringAsFixed(1)}%',
                  color: colors[index % colors.length],
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final List<CategorySpending> categories;

  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final category = categories[index];
          final color = colors[index % colors.length];

          return ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            title: Text(
              category.category,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${category.transactionCount} transactions'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(category.amount, context.watch<CurrencyCubit>().state),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${category.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MonthComparisonCard extends StatelessWidget {
  final MonthlyComparison comparison;

  const _MonthComparisonCard({required this.comparison});

  String _formatMonth(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatMonth(comparison.previousMonth),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatCurrency(comparison.previousTotal, context.watch<CurrencyCubit>().state),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  comparison.isIncrease
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: comparison.isIncrease ? Colors.red : Colors.green,
                  size: 32,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatMonth(comparison.currentMonth),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatCurrency(comparison.currentTotal, context.watch<CurrencyCubit>().state),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (comparison.isIncrease ? Colors.red : Colors.green)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    comparison.isIncrease
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: comparison.isIncrease ? Colors.red : Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${comparison.percentageChange.toStringAsFixed(1)}% ${comparison.isIncrease ? "increase" : "decrease"}',
                    style: TextStyle(
                      color: comparison.isIncrease ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (comparison.categoryComparisons.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Category Changes',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...comparison.categoryComparisons.values
                  .where((c) => c.percentageChange > 5)
                  .take(5)
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(child: Text(c.category)),
                          Icon(
                            c.isIncrease
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 16,
                            color: c.isIncrease ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${c.percentageChange.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: c.isIncrease ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpendingTrendChart extends StatelessWidget {
  final SpendingTrend trend;

  const _SpendingTrendChart({required this.trend});

  String _formatMonth(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (trend.monthlyData.isEmpty) {
      return Card(
        child: Container(
          height: 250,
          alignment: Alignment.center,
          child: Text(
            'No trend data',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          final symbol = context.watch<CurrencyCubit>().state.symbol;
                          return Text(
                            '$symbol${(value / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= trend.monthlyData.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            _formatMonth(
                              trend.monthlyData[value.toInt()].month,
                            ),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: trend.monthlyData
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.amount))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 1,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TrendStat(
                  label: 'Average',
                  value: formatCurrency(trend.averageMonthlySpending, context.watch<CurrencyCubit>().state),
                ),
                _TrendStat(label: 'Top Category', value: trend.topCategory),
                _TrendStat(
                  label: 'Trend',
                  value: trend.overallTrend == TrendDirection.increasing
                      ? 'Rising'
                      : trend.overallTrend == TrendDirection.decreasing
                      ? 'Falling'
                      : 'Stable',
                  color: trend.overallTrend == TrendDirection.increasing
                      ? Colors.red
                      : trend.overallTrend == TrendDirection.decreasing
                      ? Colors.green
                      : Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _TrendStat({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
