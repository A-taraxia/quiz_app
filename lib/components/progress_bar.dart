import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final double percent;

  const ProgressBar({super.key, this.percent = 0.0});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 100,
      lineWidth: 10,
      percent: percent,
      progressColor: Colors.deepPurple,
      backgroundColor: Colors.deepPurple.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        '${(percent * 100).toStringAsFixed(0)}%',
        style: TextStyle(fontSize: 50),
      ),
    );
  }
}
