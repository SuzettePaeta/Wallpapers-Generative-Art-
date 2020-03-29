import 'dart:developer' as developer;
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
//    tiledLines(canvas);
    mondrian(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }

  void tiledLines(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var x = 0; x < frameSize; x += step) {
      for (var y = 0; y < frameSize; y += step) {
        drawTiledLines(canvas, paint, x.toDouble(), y.toDouble(),
            step.toDouble(), step.toDouble());
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

  void drawTiledLines(Canvas canvas, Paint paint, double x, double y,
      double width, double height) {
    var leftToRight = Random().nextDouble() >= 0.5;
    if (leftToRight) {
      canvas.drawLine(Offset(x, y), Offset(x + width, y + height), paint);
    } else {
      canvas.drawLine(Offset(x + width, y), Offset(x, y + height), paint);
    }
  }

  var squares = List<Square>();
  var white = Color(0xffffffff);
  var colors = [Color(0xffD40920), Color(0xff1356A2), Color(0xffF7D842)];

  void mondrian(Canvas canvas) {
    var step = frameSize / 7;
    var square = Square(0, 0, frameSize, frameSize);

    squares.add(square);

    for (var i = 0.toDouble(); i < frameSize; i += step) {
      splitSquaresWith(null, i);
      splitSquaresWith(i, null);
    }

    for (var i = 0; i < squares.length; i++) {
      developer.log(squares.elementAt(i).toString());
    }

    drawMondrian(canvas);
  }

  void drawMondrian(Canvas canvas) {
    for (var i = 0; i < colors.length; i++) {
      squares[(Random().nextInt(squares.length))].color = colors[i];
    }

    for (var i = 0; i < squares.length; i++) {
      var rect = Rect.fromLTWH(
          squares[i].x, squares[i].y, squares[i].width, squares[i].height);

      var rectColor = white;
      if (squares[i].color != null) {
        rectColor = squares[i].color;
      }

      final paint = Paint()
        ..color = rectColor
        ..strokeWidth = 1
        ..strokeCap = StrokeCap.square;

      canvas.drawRect(rect, paint);

      final paintBorder = Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      final pointMode = ui.PointMode.polygon;
      final points = [
        Offset(squares[i].x, squares[i].y),
        Offset(squares[i].x + squares[i].width, squares[i].y),
        Offset(
            squares[i].x + squares[i].width, squares[i].y + squares[i].height),
        Offset(squares[i].x, squares[i].y + squares[i].height),
        Offset(squares[i].x, squares[i].y),
      ];

      canvas.drawPoints(pointMode, points, paintBorder);
    }
  }

  void splitSquaresWith(double x, double y) {
    for (var i = squares.length - 1; i >= 0; i--) {
      var square = squares.elementAt(i);

      if (x != null) {
        if (x > square.x && x < square.x + square.width) {
          if (Random().nextDouble() > 0.5) {
            squares.removeAt(i);
            splitOnX(square, x);
          }
        }
      }
      if (y != null) {
        if (y > square.y && y < square.y + square.height) {
          if (Random().nextDouble() > 0.5) {
            squares.removeAt(i);
            splitOnY(square, y);
          }
        }
      }
    }
  }

  void splitOnY(Square square, double splitAt) {
    var squareA = Square(square.x, square.y, square.width,
        square.height - (square.height - splitAt + square.y));

    var squareB = Square(
        square.x, splitAt, square.width, square.height - splitAt + square.y);

    squares.add(squareA);
    squares.add(squareB);
  }

  void splitOnX(Square square, double splitAt) {
    var squareA = Square(square.x, square.y,
        square.width - (square.width - splitAt + square.x), square.height);

    var squareB = Square(
        splitAt, square.y, square.width - splitAt + square.x, square.height);

    squares.add(squareA);
    squares.add(squareB);
  }
}

class Square {
  double x;
  double y;
  double width;
  double height;
  Color color = Color(0xffffffff);

  Square(double pointX1, double pointY1, double pointX2, double pointY2) {
    this.x = pointX1;
    this.y = pointY1;
    this.width = pointX2;
    this.height = pointY2;
  }

  @override
  String toString() {
    return 'Square{x: $x, y: $y, width: $width, height: $height, color: $color}';
  }
}
