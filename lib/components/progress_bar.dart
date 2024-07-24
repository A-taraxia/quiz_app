import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_app/services/auth/auth_services.dart';

class ProgressBar extends StatefulWidget {
  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double percent = 0.0;
  final AuthServices _authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    int totalScore = await _authServices.getTotalQuizScore();
    setState(() {
      percent = totalScore / 25;
    });
  }

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
