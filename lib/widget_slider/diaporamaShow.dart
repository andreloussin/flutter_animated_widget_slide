import 'package:flutter/material.dart';

class DiaporamaShow extends StatefulWidget {
  List<Slide> slides;
  List<Widget> children;
  Slide Function(Widget child)? build;
  DiaporamaShowController? controller;
  bool startAutoScroll = false;
  void Function()? onDiapoEnd;
  void Function()? onDiapoPrev;
  void Function(int index, double step)? stepListener;

  DiaporamaShow(
      {Key? key,
      DiaporamaShowController? controller,
      void Function(int index, double step)? stepListener,
      this.startAutoScroll = false,
      this.slides = const [],
      this.onDiapoEnd,
      this.onDiapoPrev,
      this.children = const []})
      : super(key: key) {
    this.controller = controller ?? DiaporamaShowController();
    this.stepListener = stepListener ?? (index, step) {};
  }

  static DiaporamaShow builder(
      {DiaporamaShowController? controller,
      void Function(int index, double step)? stepListener,
      bool startAutoScroll = false,
      List<Widget> items = const [],
      void Function()? onDiapoEnd,
      void Function()? onDiapoPrev,
      Slide Function(Widget child)? build}) {
    build = build ??
        (child) {
          print("$child");
          return Slide(
            child: child,
          );
        };
    List<Slide> li = [];
    for (Widget i in items) {
      li.add(build(i));
    }
    return DiaporamaShow(
        controller: controller,
        stepListener: stepListener,
        startAutoScroll: startAutoScroll,
        onDiapoEnd: onDiapoEnd,
        onDiapoPrev: onDiapoPrev,
        slides: li,
        children: items);
  }

  @override
  State<StatefulWidget> createState() => DiaporamaShowState(
        controller: controller,
      );
}

class DiaporamaShowState extends State<DiaporamaShow> {
  int index = 0;
  double step = 0.0;
  DiaporamaShowController? controller;
  bool autoNexting = true;
  bool playing = false;

  DiaporamaShowState({this.controller}) {
    controller?.setParent(this);
  }

  @override
  void initState() {
    super.initState();
    if (widget.startAutoScroll && widget.slides.isNotEmpty) {
      autoNextIn(widget.slides.elementAt(index).waitTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.slides.isNotEmpty ? widget.slides.elementAt(index) : null,
    );
  }

  int next() {
    setState(() {
      step = 0;
      if (index + 1 >= widget.slides.length) {
        stop();
        try {
          widget.onDiapoEnd!();
        } catch (e) {}
      } else {
        index++;
      }
    });
    if (autoNexting) {
      autoNextIn(widget.slides.elementAt(index).waitTime);
    }
    return index;
  }

  int prev() {
    setState(() {
      step = 0;
      if (index - 1 <= 0) {
        stop();
        try {
          widget.onDiapoPrev!();
        } catch (e) {}
      } else {
        index--;
      }
    });
    if (autoNexting) {
      autoNextIn(widget.slides.elementAt(index).waitTime);
    }
    return index;
  }

  void autoNextIn(int milliseconds) async {
    if (milliseconds < 0) throw ("time must be positive");
    play();
    step = 0;
    double passed = 0.0;
    while (passed < milliseconds) {
      print("step: $step");
      await Future.delayed(const Duration(milliseconds: 100));
      passed += playing ? 100 : 0;
      if (passed >= milliseconds) {
        passed = milliseconds as double;
      }
      step = passed / milliseconds;
      print("${widget.stepListener}");
      widget.stepListener!(index, step);
    }
    next();
  }

  void pause() {
    playing = false;
  }

  void play() {
    playing = true;
  }

  void stop() {
    autoNexting = false;
  }

  void start() {
    autoNexting = true;
    if (widget.slides.isNotEmpty) {
      autoNextIn(widget.slides.elementAt(index).waitTime);
    }
  }
}

class Slide extends StatelessWidget {
  final Widget? child;
  int waitTime = 2000;

  Slide({Key? key, int waitTime = 2000, this.child}) : super(key: key) {
    this.waitTime = (500 <= waitTime && waitTime <= 10000)
        ? waitTime
        : throw ("waitTime = $waitTime is not in [500,100]");
  }

  @override
  Widget build(BuildContext context) {
    return child ?? Container();
  }
}

class DiaporamaShowController {
  DiaporamaShowState? parent;

  void setParent(DiaporamaShowState parent) {
    this.parent = parent;
  }

  // void next() {
  //   parent!.next();
  // }

  // void prev() {
  //   parent!.prev();
  // }

  // void autoNextIn(int milliseconds) {
  //   parent!.autoNextIn(milliseconds);
  // }

  // void pause() {
  //   parent!.pause();
  // }

  // void play() {
  //   parent!.play();
  // }

  // void stop() {
  //   parent!.stop();
  // }

  // int index() => parent!.index;
}
