import 'dart:math';

import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  const ResultBox(
      {super.key, required this.result, required this.questionLength});
  final int result;
  final int questionLength;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Padding(
        padding: const EdgeInsets.all(70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Result:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomPaint(
              size: Size(180, 180), // Increased width and height of the star
              painter: StarPainter(
                result: result,
                questionLength: questionLength,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              result == questionLength.floor() / 2
                  ? 'Just Barely!'
                  : result < questionLength / 2
                      ? 'Try Again!'
                      : result == questionLength
                          ? 'Perfect!'
                          : 'Good!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {},
              child: const Text('Start Over'),
            )
          ],
        ),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  final int result;
  final int questionLength;
  final TextStyle textStyle;

  StarPainter({
    required this.result,
    required this.questionLength,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = result == questionLength / 2
          ? Colors.yellow.shade700
          : result < questionLength / 2
              ? Colors.red
              : Colors.green
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double outerRadius = size.width / 2;
    final double innerRadius =
        outerRadius / 2.2; // Adjusted inner radius for better scaling
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 5; i++) {
      double angle = (i * 72) * (pi / 180);
      double x = center.dx + outerRadius * cos(angle);
      double y = center.dy - outerRadius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle = ((i + 0.5) * 72) * (pi / 180);
      x = center.dx + innerRadius * cos(angle);
      y = center.dy - innerRadius * sin(angle);
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);

    final TextSpan span = TextSpan(
      style: textStyle,
      text: '$result/$questionLength',
    );
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
