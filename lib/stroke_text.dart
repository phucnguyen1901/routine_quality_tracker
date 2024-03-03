import 'package:flutter/material.dart';
import 'package:routine_quality_tracker/style.dart';

class StrokeText extends StatelessWidget {
  const StrokeText(
      {super.key,
      required this.text,
      this.insideColor,
      this.outsideColor,
      this.fontSize});
  final String text;
  final Color? insideColor;
  final Color? outsideColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          text,
          style: styles.copyWith(
            fontSize: fontSize ?? 23,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = outsideColor ?? const Color.fromRGBO(227, 126, 126, 1),
            fontWeight: FontWeight.w700,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: styles.copyWith(
            fontSize: fontSize ?? 23,
            color: insideColor ?? Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
