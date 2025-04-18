import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineCHART_temperature extends StatefulWidget {
  LineCHART_temperature({super.key});

  @override
  State<LineCHART_temperature> createState() => _LineCHART_temperatureState();
}

class _LineCHART_temperatureState extends State<LineCHART_temperature> {
  List<FlSpot> spots = [];
  int time = 0;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _startUpdating();
  }

  void _startUpdating() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Генерируем случайную температуру в диапазоне 18–30 градусов
        double temperature = 24 + random.nextDouble() * 4 - 2; // Отклонение ±2 градуса

        spots.add(FlSpot(time.toDouble(), temperature));

        if (spots.length > 20) {
          spots.removeAt(0);
        }
        time++;
      });
    });
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      color: Color.fromARGB(255, 14, 47, 73),
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
    );
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Температура',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            maxContentWidth: 100,
                            getTooltipColor: (touchedSpot) => Colors.black,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((touchedSpot) {
                                return LineTooltipItem(
                                  '${touchedSpot.y.toStringAsFixed(2)}°C',
                                  TextStyle(
                                    color: touchedSpot.bar.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                          handleBuiltInTouches: true,
                          getTouchLineStart: (data, index) => 0,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            color: Colors.pink,
                            spots: spots,
                            isCurved: true,
                            isStrokeCapRound: true,
                            barWidth: 3,
                            belowBarData: BarAreaData(show: false),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        minY: 18,
                        maxY: 30,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) =>
                                  leftTitleWidgets(value, meta, constraints.maxWidth),
                              reservedSize: 56,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Убрали ось X
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: true,
                          horizontalInterval: 2,
                          verticalInterval: 5,
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
