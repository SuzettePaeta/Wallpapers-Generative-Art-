import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Wallpapers generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xff242526),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPaint(
              size: Size(320, 320),
              painter: MyPainter(),
            )
          ],
        ),
      ),
      backgroundColor: Color(0xffffffff),
    );
  }
}

class MyPainter extends CustomPainter {
  var frameSize = 320.toDouble();
  var step = 20;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var x = 0; x < frameSize; x += step) {
      for (var y = 0; y < frameSize; y += step) {
        draw(canvas, paint, x.toDouble(), y.toDouble(), step.toDouble(),
            step.toDouble());
      }
    }

    final pointMode = ui.PointMode.polygon;
    final points = [
      Offset(0, 0),
      Offset(0, frameSize),
      Offset(frameSize, frameSize),
      Offset(frameSize, 0),
      Offset(0, 0),
    ];

    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }

  void draw(Canvas canvas, Paint paint, double x, double y, double width,
      double height) {
    var leftToRight = Random().nextDouble() >= 0.5;
    if (leftToRight) {
      canvas.drawLine(Offset(x, y), Offset(x + width, y + height), paint);
    } else {
      canvas.drawLine(Offset(x + width, y), Offset(x, y + height), paint);
    }
  }
}
