import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TestPie extends StatelessWidget {
  const TestPie({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
          swapAnimationCurve: Curves.easeInOut,
          swapAnimationDuration: const Duration(milliseconds: 750),
          PieChartData(sections: [
            PieChartSectionData(value: 40, color: Colors.amber),
            PieChartSectionData(value: 50, color: Colors.blue)
          ])
        );
  }
}