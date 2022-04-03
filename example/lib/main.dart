import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final _offsets = <Offset>[];
class _MyHomePageState extends State<MyHomePage> {
  late double _trimPercent;
  late PathTrimOrigin _trimOrigin;

  @override
  void initState() {
    super.initState();
    _trimPercent = 0.2;
    _trimOrigin = PathTrimOrigin.begin;
  }

  void setTrimPercent(double value) {
    setState(() {
      _trimPercent = value;
    });
  }

  void toggleTrimOrigin(PathTrimOrigin? value) {
    setState(() {
      switch (_trimOrigin) {
        case PathTrimOrigin.begin:
          _trimOrigin = PathTrimOrigin.end;
          break;
        case PathTrimOrigin.end:
          _trimOrigin = PathTrimOrigin.begin;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: <Tab>[
              const Tab(text: 'Path Trim'),
            ],
          ),
        ),
        body: GestureDetector(
          onPanDown: (details) {
            final localPosition = context.findRenderObject() as RenderBox;
            final renderBox = localPosition.globalToLocal(details.globalPosition);
            setState(() {
              _offsets.add(renderBox);
            });
          },
          onPanUpdate: (details) {
            final localPosition = context.findRenderObject() as RenderBox;
            final renderBox = localPosition.globalToLocal(details.globalPosition);
            setState(() {
              _offsets.add(renderBox);
            });
          },
          onPanEnd: (details) {
            final renderBox = Offset(0.0, 0.0);
            setState(() {
              _offsets.add(renderBox);
            });
          },
          child: Center(
              child: CustomPaint(
                painter: PainterPen(_offsets),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset("assets/images/lake.jpg"),
                ),
              )
          )
        )
      )
    );
  }
}
class PainterPen extends CustomPainter{
  final List<Offset> offsets;
  PainterPen(this.offsets): super();
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final paint = Paint()
      ..color = Colors.deepPurple
      ..isAntiAlias = true
      ..strokeWidth = 3.0;

    for(var index = 1; index<offsets.length; ++index){
      if(offsets[index-1]!=null&&offsets[index]!=null){
        canvas.drawLine(offsets[index-1], offsets[index], paint);
      }
      else if(offsets[index-1]!=null&&offsets[index]==null) {
        canvas.drawPoints(
            PointMode.points,
            [offsets[index-1]],
            paint
        );
      }
      else{
        canvas.drawPoints(PointMode.points,
            [offsets[index-1]],
            paint);
      }

    }

  }

  @override
  bool shouldRepaint( CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}
final Paint black = Paint()
  ..color = Colors.black
  ..strokeWidth = 1.0
  ..style = PaintingStyle.stroke;

class TrimPathPainter extends CustomPainter {
  TrimPathPainter(this.percent, this.origin);

  final double percent;
  final PathTrimOrigin origin;

  final Path p = Path()
    ..moveTo(100.0, 100.0)
    ..quadraticBezierTo(125.0, 20.0, 200.0, 100.0)
    ..quadraticBezierTo(125.0, 220.0, 100.0, 100.0);

  @override
  bool shouldRepaint(TrimPathPainter oldDelegate) =>
      oldDelegate.percent != percent;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(trimPath(p, percent, origin: origin), black);
  }
}

class DashPathPainter extends CustomPainter {
  final Path p = Path()
    ..moveTo(100.0, 100.0)
    ..quadraticBezierTo(125.0, 20.0, 200.0, 100.0)
    ..quadraticBezierTo(125.0, 220.0, 100.0, 100.0)
    ..addRect(const Rect.fromLTWH(0.0, 0.0, 50.0, 50.0));

  @override
  bool shouldRepaint(DashPathPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        dashPath(
          p,
          dashArray: CircularIntervalList<double>(
            <double>[5.0, 2.5],
          ),
        ),
        black);
  }
}

class PathTestPainter extends CustomPainter {
  PathTestPainter(String path) : p = parseSvgPathData(path);

  final Path p;

  @override
  bool shouldRepaint(PathTestPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(p, black);
  }
}
