import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/Slide/slide.dart';
import 'package:flutter_animated_widget_slide/Slide/video_slide.dart';

class DiaporamaShow extends StatefulWidget {
  List<Slide> slides;
  List<Widget> children;
  Slide Function(Widget child)? build;
  late final DiaporamaShowController? controller;
  bool startAutoScroll = false;
  void Function()? onDiapoEnd;
  void Function()? onDiapoPrev;
  void Function(int index, double step)? stepListener;

  DiaporamaShow(
      {Key? key,
      this.controller,
      void Function(int index, double step)? stepListener,
      this.startAutoScroll = false,
      this.slides = const [],
      this.onDiapoEnd,
      this.onDiapoPrev,
      this.children = const []})
      : super(key: key) {
    controller ??= DiaporamaShowController();
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
          return child is Slide
              ? child
              : Slide(
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
  State<StatefulWidget> createState() => DiaporamaShowState();
}

class DiaporamaShowState extends State<DiaporamaShow> {
  int index = 0;
  double step = 0.0;
  bool autoNexting = true;
  bool isAutoNextingNow = false;
  bool exitAutoNextRequested = false;
  bool playing = false;

  DiaporamaShowState();

  @override
  void initState() {
    super.initState();
    if (widget.startAutoScroll && widget.slides.isNotEmpty) {
      autoNext();
    }
    widget.controller?.setParent(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.slides.isNotEmpty ? widget.slides.elementAt(index) : null,
    );
  }

  Future<int> next() async {
    if (isAutoNextingNow) {
      do {
        exitAutoNextRequested = true;
        print("waitting for isAutoNextingNow == false");
        await Future.delayed(const Duration(milliseconds: 200));
        print(
            "after 200ms isAutoNextingNow == &isAutoNextingNow && exitAutoNextRequested == $exitAutoNextRequested");
      } while (isAutoNextingNow);
    }
    setState(() {
      step = 0;
      if (index + 1 >= widget.slides.length) {
        // stop();
        try {
          widget.onDiapoEnd!();
        } catch (e) {}
      } else {
        index++;
        if (autoNexting) {
          autoNext();
        }
      }
    });
    return index;
  }

  Future<int> prev() async {
    if (isAutoNextingNow) {
      do {
        exitAutoNextRequested = true;
        print("waitting for isAutoNextingNow == false");
        await Future.delayed(const Duration(milliseconds: 200));
        print(
            "after 200ms isAutoNextingNow == &isAutoNextingNow && exitAutoNextRequested == $exitAutoNextRequested");
      } while (isAutoNextingNow);
    }
    setState(() {
      step = 0;
      if (index - 1 < 0) {
        // stop();
        try {
          widget.onDiapoPrev!();
        } catch (e) {}
      } else {
        index--;
        if (autoNexting) {
          autoNext();
        }
      }
    });
    print("index in prev $index");
    return index;
  }

  void autoNext() async {
    play();
    step = 0;
    double passed = 0.0;
    isAutoNextingNow = true;
    int milliseconds = widget.slides.elementAt(index).waitTime;
    while (passed < milliseconds && !exitAutoNextRequested) {
      milliseconds = widget.slides.elementAt(index).waitTime;
      await Future.delayed(const Duration(milliseconds: 100));
      passed +=
          (playing && !widget.slides.elementAt(index).needPause) ? 100 : 0;
      if (passed >= milliseconds) {
        passed = milliseconds + 0.0;
      }
      step = passed / milliseconds;
      widget.stepListener!(index, step);
    }
    exitAutoNextRequested = false;
    isAutoNextingNow = false;
    next();
  }

  void pause() {
    if (widget.slides.elementAt(index) is VideoSlide) {
      (widget.slides.elementAt(index) as VideoSlide).pause();
    }
    playing = false;
  }

  void play() {
    if (widget.slides.elementAt(index) is VideoSlide) {
      (widget.slides.elementAt(index) as VideoSlide).play();
    }
    playing = true;
  }

  void stop() {
    autoNexting = false;
  }

  void start() {
    autoNexting = true;
    if (widget.slides.isNotEmpty) {
      autoNext();
    }
  }
}

class DiaporamaShowController {
  late final DiaporamaShowState? parent;

  void setParent(DiaporamaShowState parent) {
    this.parent = parent;
  }

  void next() {
    parent!.next();
  }

  void prev() {
    parent!.prev();
  }

  void autoNext() {
    parent!.autoNext();
  }

  void pause() {
    parent!.pause();
  }

  void play() {
    parent!.play();
  }

  void stop() {
    parent!.stop();
  }

  int index() => parent!.index;
}
