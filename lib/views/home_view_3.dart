import 'package:flutter/material.dart';
import 'package:flutter_animation_course/views/home_view_4.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

class HomeView3 extends StatefulWidget {
  const HomeView3({super.key});

  @override
  State<HomeView3> createState() => _HomeView3State();
}

class _HomeView3State extends State<HomeView3> with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _animation = Tween<double>(begin: 0, end: pi * 2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();
    var widthAndHeight = 100.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation 3 '),
        centerTitle: true,
        elevation: 5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50, width: double.infinity),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeView4()));
            },
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _xController,
                _yController,
                _zController,
              ]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(_animation.evaluate(_xController))
                    ..rotateY(_animation.evaluate(_yController))
                    ..rotateZ(_animation.evaluate(_zController)),
                  child: Stack(
                    children: [
                      // back
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..translate(Vector3(0, 0, -widthAndHeight)),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.purple,
                        ),
                      ),
                      // left side
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(pi/2),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.red,
                        ),
                      ),
                      // Right side
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(-pi/2),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.blue,
                        ),
                      ),
                      // Front
                      Container(
                        height: widthAndHeight,
                        width: widthAndHeight,
                        color: Colors.green,
                      ),
                      // Top side
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX(-pi/2),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.orange,
                        ),
                      ),
                      // Top side
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(pi/2),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
