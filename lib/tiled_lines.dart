import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TiledLines extends CustomPainter {

  //var frameSize = 320.toDouble();
  var step = 20;

  final double width;
  final double height;

  TiledLines({this.width,this.height});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    tiledLines(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void tiledLines(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var x = 0; x < width; x += step) {
      for (var y = 0; y < height; y += step) {
        drawTiledLines(canvas, paint, x.toDouble(), y.toDouble(),
            step.toDouble(), step.toDouble());
      }
    }

    final pointMode = ui.PointMode.polygon;
    final points = [
      Offset(0, 0),
      Offset(0, height),
      Offset(width, height),
      Offset(width, 0),
      Offset(0, 0),
    ];

    canvas.drawPoints(pointMode, points, paint);
  }

  void drawTiledLines(Canvas canvas, Paint paint, double x, double y,
      double width, double height) {
    var leftToRight = Random().nextDouble() >= 0.5;
    if (leftToRight) {
      canvas.drawLine(Offset(x, y), Offset(x + width, y + height), paint);
    } else {
      canvas.drawLine(Offset(x + width, y), Offset(x, y + height), paint);
    }
  }
}
