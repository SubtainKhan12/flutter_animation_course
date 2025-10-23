import 'package:flutter/material.dart';
import 'dart:math' show pi;

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    var path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
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
      radius: Radius.elliptical(size.width / 2, size.height / 2),
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

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class HomeView2 extends StatefulWidget {
  const HomeView2({super.key});

  @override
  State<HomeView2> createState() => _HomeView2State();
}

class _HomeView2State extends State<HomeView2> with TickerProviderStateMixin {
  late AnimationController _counterClockWiseRotationController;
  late Animation<double> _counterClockWiseRotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockWiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _counterClockWiseRotationAnimation = Tween<double>(begin: 0, end: -(pi / 2))
        .animate(
          CurvedAnimation(
            parent: _counterClockWiseRotationController,
            curve: Curves.bounceOut,
          ),
        );
    // flip animation
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
    );

    // status Listener
    _counterClockWiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation =
            Tween<double>(
              begin: _flipAnimation.value,
              end: _flipAnimation.value + pi,
            ).animate(
              CurvedAnimation(
                parent: _flipController,
                curve: Curves.bounceOut,
              ),
            );

        // reset the flip controller and start the animation
        _flipController
          ..reset()
          ..forward();
      }
    });

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockWiseRotationAnimation =
            Tween<double>(
              begin: _counterClockWiseRotationAnimation.value,
              end: _counterClockWiseRotationAnimation.value + -(pi / 2),
            ).animate(
              CurvedAnimation(
                parent: _counterClockWiseRotationController,
                curve: Curves.bounceOut,
              ),
            );
        _counterClockWiseRotationController
          ..reset()
          ..forward();
      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _counterClockWiseRotationController.dispose();
    _flipController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockWiseRotationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation 2'),
        centerTitle: true,
        elevation: 5,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _counterClockWiseRotationAnimation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockWiseRotationAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _flipController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper: HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _flipController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper: HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.yellow,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
