import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  const StrokeText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: 23,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = const Color.fromRGBO(227, 126, 126, 1),
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: const TextStyle(
            fontSize: 23,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
