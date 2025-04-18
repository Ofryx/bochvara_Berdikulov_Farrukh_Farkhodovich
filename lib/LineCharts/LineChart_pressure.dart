import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineCHART_pressure extends StatefulWidget {
  LineCHART_pressure({super.key});

  @override
  State<LineCHART_pressure> createState() => _LineCHART_pressureState();
}

class _LineCHART_pressureState extends State<LineCHART_pressure> {
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
        // Генерируем случайное давление в диапазоне 950-1050 мм рт. ст.
        double pressure = 1000 + random.nextDouble() * 50 - 25; // Отклонение ±25

        spots.add(FlSpot(time.toDouble(), pressure));

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
      fontSize: min(12, 18 * chartWidth / 300), // Уменьшаем размер шрифта
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
                'Давление',
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
                                  '${touchedSpot.y.toStringAsFixed(2)} мм рт. ст.',
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
                            color: Colors.green,
                            spots: spots,
                            isCurved: true,
                            isStrokeCapRound: true,
                            barWidth: 3,
                            belowBarData: BarAreaData(show: false),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        minY: 950, // Минимальное давление
                        maxY: 1050, // Максимальное давление
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
