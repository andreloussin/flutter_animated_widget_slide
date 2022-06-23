import 'package:flutter/material.dart';

class Slide extends StatelessWidget {
  Widget? child;
  int waitTime = 2000;
  bool read = false;
  bool needPause = false;

  Slide(
      {Key? key,
      int waitTime = 2000,
      this.child,
      this.read = false,
      this.needPause = false})
      : super(key: key) {
    this.waitTime = (500 <= waitTime && waitTime <= 10000)
        ? waitTime
        : throw ("waitTime = $waitTime is not in [500,100]");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Center(child: child));
  }

  void play() {}

  void pause() {}
}
