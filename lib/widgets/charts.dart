// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class RealtimeChart extends StatelessWidget {
  final List<double> dataPoints;
  final Color lineColor;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double maxY;
  final String label;

  const RealtimeChart({
    super.key,
    required this.dataPoints,
    required this.lineColor,
    required this.gradientStartColor,
    required this.gradientEndColor,
    this.maxY = 100,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    for (int i = 0; i < dataPoints.length; i++) {
      spots.add(FlSpot(i.toDouble(), dataPoints[i]));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        minX: 0,
        maxX: (dataPoints.length - 1).toDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[800]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: false,
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  gradientStartColor,
                  gradientEndColor,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CpuUsageChart extends StatelessWidget {
  final List<double> cpuHistory;

  const CpuUsageChart({
    super.key,
    required this.cpuHistory,
  });

  @override
  Widget build(BuildContext context) {
    return RealtimeChart(
      dataPoints: cpuHistory,
      lineColor: Colors.blue,
      gradientStartColor: Colors.blue.withOpacity(0.5),
      gradientEndColor: Colors.blue.withOpacity(0.0),
      maxY: 100,
      label: 'CPU %',
    );
  }
}

class MemoryUsageChart extends StatelessWidget {
  final List<double> memoryHistory;

  const MemoryUsageChart({
    super.key,
    required this.memoryHistory,
  });

  @override
  Widget build(BuildContext context) {
    return RealtimeChart(
      dataPoints: memoryHistory,
      lineColor: Colors.purple,
      gradientStartColor: Colors.purple.withOpacity(0.5),
      gradientEndColor: Colors.purple.withOpacity(0.0),
      maxY: 100,
      label: 'RAM %',
    );
  }
}

class NetworkUsageChart extends StatelessWidget {
  final List<double> downloadHistory;
  final List<double> uploadHistory;

  const NetworkUsageChart({
    super.key,
    required this.downloadHistory,
    required this.uploadHistory,
  });

  @override
  Widget build(BuildContext context) {
    List<FlSpot> downloadSpots = [];
    List<FlSpot> uploadSpots = [];
    
    double maxValue = 1.0;
    for (int i = 0; i < downloadHistory.length; i++) {
      downloadSpots.add(FlSpot(i.toDouble(), downloadHistory[i]));
      uploadSpots.add(FlSpot(i.toDouble(), uploadHistory[i]));
      maxValue = math.max(maxValue, math.max(downloadHistory[i], uploadHistory[i]));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxValue * 1.2,
        minX: 0,
        maxX: (downloadHistory.length - 1).toDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[800]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: downloadSpots,
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.withOpacity(0.3),
                  Colors.green.withOpacity(0.0),
                ],
              ),
            ),
          ),
          LineChartBarData(
            spots: uploadSpots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.withOpacity(0.3),
                  Colors.orange.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
