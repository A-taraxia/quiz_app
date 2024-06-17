import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({super.key, required this.option, required this.isClicked});
  final String option;
  final bool isClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('clicked');
      },
      child: Card(
        child: ListTile(
          title: Text(
            option,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
