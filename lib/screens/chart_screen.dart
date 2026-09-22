import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/trade_theme.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Chart
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _buildChartCard(context),
              ),
            ),

            // Trading Controls
            _buildTradingControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradeColors.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BTC/USDT',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '\$64,230.50',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: TradeColors.primaryText,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              _buildTimePeriodButton(context, '1H', '1 час'),
              const SizedBox(width: 8),
              _buildTimePeriodButton(context, '4H', '4 часа'),
              const SizedBox(width: 8),
              _buildTimePeriodButton(context, '1D', '24 часа'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodButton(
      BuildContext context, String label, String tooltip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: TradeColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Tooltip(
        message: tooltip,
        child: Text(
          label,
          style: TextStyle(
            color: TradeColors.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TradeColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: TradeColors.primaryPurple.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BTC/USDT - График',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.zoom_out),
                      color: TradeColors.primaryText,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.zoom_in),
                      color: TradeColors.primaryText,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                mainData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: TradeColors.primaryPurple.withValues(alpha: 0.1),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: TradeColors.primaryPurple.withValues(alpha: 0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '\$${value.toInt()}',
                style: TextStyle(
                  color: TradeColors.secondaryText,
                  fontSize: 10,
                ),
              );
            },
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              const times = [
                '00:00',
                '04:00',
                '08:00',
                '12:00',
                '16:00',
                '20:00'
              ];
              return Text(
                times[value.toInt() % times.length],
                style: TextStyle(
                  color: TradeColors.secondaryText,
                  fontSize: 10,
                ),
              );
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: TradeColors.secondaryText,
                  fontSize: 10,
                ),
              );
            },
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: TradeColors.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      minX: 0,
      maxX: 5,
      minY: 64000,
      maxY: 64500,
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 64000),
            const FlSpot(1, 64100),
            const FlSpot(2, 64050),
            const FlSpot(3, 64200),
            const FlSpot(4, 64150),
            const FlSpot(5, 64230),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              TradeColors.primaryPurple,
              TradeColors.lightPurple,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: TradeColors.primaryPurple,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                TradeColors.primaryPurple.withValues(alpha: 0.3),
                TradeColors.primaryPurple.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTradingControls(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradeColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTradingButton(
            context,
            Icons.remove_circle_outline,
            'SELL',
            TradeColors.errorRed,
          ),
          Container(
            width: 1,
            height: 40,
            color: TradeColors.primaryPurple.withValues(alpha: 0.3),
          ),
          _buildTradingButton(
            context,
            Icons.add_circle_outline,
            'BUY',
            TradeColors.successGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildTradingButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
