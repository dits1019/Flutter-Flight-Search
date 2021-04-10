import 'package:flutter/material.dart';

//점 위젯
class AnimatedDot extends AnimatedWidget {
  final Color color;

  AnimatedDot({Key key, Animation<double> animation, @required this.color})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Positioned(
        top: animation.value,
        child: Container(
          height: 24.0,
          width: 24.0,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xffdddddd), width: 1.0)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ));
  }
}