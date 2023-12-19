import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

class TitledCard extends StatelessWidget {
  TitledCard(
      {super.key,
      required this.child,
      required this.color,
      required this.title,
      this.width = 4.0});

  final Widget child;
  final Color color;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child:  Stack(fit: StackFit.expand, children: [
        CustomPaint(
            painter: BorderWithLabel(width: width, color: color, title: title)),
         Container(padding: EdgeInsets.all(width*2),child:child),
      ]),
    );
  }
}

class BorderWithLabel extends CustomPainter {
  BorderWithLabel({required this.color, required this.title, this.width = 4.0});

  final Color color;
  final String title;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    TextStyle textStyle = TextStyle(
        fontSize: width * 4, color: color, fontWeight: FontWeight.bold);
    final textSpan = TextSpan(
      text: title,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final xCenter = (size.width - textPainter.width) / 6;
    final yCenter = (-width / 2);
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
    Path path = Path()
      ..moveTo(width, width / 2)
      ..lineTo((size.width - textPainter.width) / 6, width / 2)
      ..moveTo(
          ((size.width - textPainter.width) / 6) + textPainter.width, width / 2)
      ..lineTo(size.width - width, width / 2)
      ..arcTo(
          Rect.fromPoints(Offset(size.width - width * 2, width / 2),
              Offset(size.width - width / 2, width)),
          1.5 * pi,
          0.5 * pi,
          true)
      ..lineTo(size.width - width / 2, size.height - width)
      ..arcTo(
          Rect.fromPoints(
              Offset(size.width - width / 2, size.height - width * 2),
              Offset(size.width - width * 2, size.height - width / 2)),
          0.0 * pi,
          0.5 * pi,
          true)
      ..lineTo(width, size.height - width / 2)
      ..arcTo(
          Rect.fromPoints(Offset(width * 2, size.height - width / 2),
              Offset(width / 2, size.height - width * 2)),
          0.5 * pi,
          0.5 * pi,
          true)
      ..lineTo(width / 2, width / 2)
      ..arcTo(
          Rect.fromPoints(Offset(width / 2, width), Offset(width, width / 2)),
          1.0 * pi,
          0.5 * pi,
          true)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderWithLabel oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderWithLabel oldDelegate) => false;
}
