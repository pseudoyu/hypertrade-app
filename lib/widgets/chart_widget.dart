import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hyper_app/screens/common_page/token_chart/token_price_page.dart';

class ChartWidget extends StatelessWidget {
  final List<CandleData> data;

  const ChartWidget({super.key, required this.data});

  double _getMaxPrice() {
    if (data.isEmpty) return 0;
    return data.map((candle) => candle.c).reduce((a, b) => a > b ? a : b);
  }

  double _getMinPrice() {
    if (data.isEmpty) return 0;
    return data.map((candle) => candle.c).reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No chart data available'),
      );
    }

    final maxYValue = _getMaxPrice();
    final minYValue = _getMinPrice();
    final priceRange = maxYValue - minYValue;
    final gridStep = priceRange / 4;

    final List<FlSpot> spots = data.asMap().entries.map((entry) {
      final index = entry.key;
      final candle = entry.value;
      return FlSpot(index.toDouble(), candle.c.toDouble());
    }).toList();

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: false,
              ),
            ),
          ],
          maxY: _getMaxPrice(),
          minX: 0,
          maxX: data.length - 1,
          minY: _getMinPrice(),
        ),
      ),
    );
  }
}
