import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Gesture TeamTrack'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _offsets = <Offset>[];

  @override
  void initState() {
    super.initState();
  }

final Stack stck = Stack();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.cloud), onPressed: () {}),
              Spacer(),
              IconButton(icon: Icon(Icons.clear), onPressed: () {_offsets.clear();}),
            ],
          ),
        ),
        body: Stack( children: <Widget>[
          Opacity(opacity: 1,child: Image.asset('assets/images/field.jpg')),
          GestureDetector(
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
            },),
          CustomPaint(size: Size(0.0, 0.0), painter: PainterPen(_offsets)),
        ],),
      )
    );
  }
}
class PainterPen extends CustomPainter{
  final List<Offset> offsets;
  PainterPen(this.offsets): super();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo
      ..isAntiAlias = true
      ..strokeWidth = 3.0;
    //offsets: -55 for chrome
    for(var index = 1; index<offsets.length; ++index){
      if(offsets[index-1]!=null&&offsets[index]!=null){
        Offset a = Offset(offsets[index-1].dx, offsets[index-1].dy-55);
        Offset b = Offset(offsets[index].dx, offsets[index].dy-55);
        canvas.drawLine(a, b, paint);
      }
      else if(offsets[index-1]!=null&&offsets[index]==null) {
        Offset a = Offset(offsets[index-1].dx, offsets[index-1].dy-55);
        canvas.drawPoints(
            PointMode.points,
            [a],
            paint
        );
      }
    }

  }

  @override
  bool shouldRepaint( CustomPainter oldDelegate) {
    return true;
  }

}
final Paint black = Paint()
  ..color = Colors.black
  ..strokeWidth = 1.0
  ..style = PaintingStyle.stroke;
