import 'package:flutter/material.dart';


enum CircleSide {left, right}

extension ToPath on CircleSide {
  Path toPath(Size size){
    var path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this){
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width/2, size.height/2),
    clockwise: clockwise,
    );

    path.close();
    return path;
  }
}


class HalfCircleClipper extends CustomClipper<Path> {

  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}

class HomeView2 extends StatefulWidget {
  const HomeView2({super.key});

  @override
  State<HomeView2> createState() => _HomeView2State();
}

class _HomeView2State extends State<HomeView2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation 2'),
        centerTitle: true,
        elevation: 5,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipPath(
              clipper: HalfCircleClipper(side: CircleSide.left),
              child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue.shade800
              ),
            ),
            ClipPath(
              clipper: HalfCircleClipper(side: CircleSide.right),
              child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.yellow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
