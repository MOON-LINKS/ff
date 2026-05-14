import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/features/analytics/analytics_enabled.dart';

class CustomBarChart extends StatelessWidget {
  final List<AnalyticsDay> analyticsDays;
  const CustomBarChart({super.key, required this.analyticsDays});

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: analyticsDays.isNotEmpty
            ? analyticsDays
                    .map(((a) => a.clicks))
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble() +
                1
            : 1,
        barGroups: analyticsDays
            .map((a) => BarChartGroupData(x: a.day, barRods: [
                  BarChartRodData(
                      toY: a.clicks.toDouble(), color: Colors.purple)
                ]))
            .toList(),
        gridData: FlGridData(drawVerticalLine: false),
        borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.black, width: 2),
              bottom: BorderSide(color: Colors.black, width: 2),
              top: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
            )),
        barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              rod.toY.toInt().toString(),
              TextStyle(color: Colors.white),
            );
          },
        )),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(color: Colors.black),
                    );
                  },
                ),
                axisNameWidget: Text(
                  AppLocalizations.of(context)!.menu_day,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                axisNameSize: 20),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(color: Colors.black),
                    );
                  },
                ),
                axisNameWidget: Text(
                  AppLocalizations.of(context)!.menu_clicks,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                axisNameSize: 20),
            rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)))));
  }
}
