import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_animated_widget_slide/main.dart';

class AnimatedWidgetSlider extends StatefulWidget {
  final double width;
  late final Widget? initial;
  late List<Widget>? contents = [
    const MyHomePage(title: "1"),
    const MyHomePage(title: "2"),
    const MyHomePage(title: "3"),
    const MyHomePage(title: "4"),
    const MyHomePage(title: "5"),
  ];
  AnimatedWidgetSlider({Key? key, required this.width, this.initial, contents})
      : super(key: key) {
    this.contents = contents != null
        ? contents
        : [
            const MyHomePage(title: "1"),
            const MyHomePage(title: "2"),
            const MyHomePage(title: "3"),
            const MyHomePage(title: "4"),
            const MyHomePage(title: "5"),
          ];
    ;
  }
  _AnimatedWidgetSliderState _bi = _AnimatedWidgetSliderState();

  @override
  State<StatefulWidget> createState() => _bi;

  void fromRight(Widget widget) {
    _bi.fromRight(widget: widget);
  }

  void fromLeft(Widget widget) {
    _bi.fromRight(widget: widget);
  }
}

class _AnimatedWidgetSliderState extends State<AnimatedWidgetSlider>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation rotateAnim;
  late Animation translateAnim;
  late Animation firstScaleAnim;
  late Animation lastScaleAnim;
  final GlobalKey widgetKey = GlobalKey();
  late RenderBox? renderBox;
  bool _turnNormal = true;
  Widget? _actual;
  Widget? _wid1;
  Widget? _wid2;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _wid1 = widget.initial;
    //_wid2 = MyHomePage(title: '222222222222222222222');
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    rotateAnim = Tween<double>(begin: 0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    translateAnim = Tween<double>(begin: 0, end: widget.width).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    firstScaleAnim = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5),
      ),
    );
    lastScaleAnim = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0),
      ),
    );
    //controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0)
          fromLeft();
        else
          fromRight();
      },
      child: Stack(
        key: widgetKey,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext _, child) {
              // Offset _offset = Offset(0, rotateAnim.value);
              return Transform(
                alignment: Alignment.center,
                transform: _turnNormal
                    ? (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(rotateAnim.value)
                      // ..scale(rotateAnim.value < math.pi / 4
                      //     ? firstScaleAnim.value
                      //     : lastScaleAnim.value)
                      ..translate(
                          -(widget.width * math.sin(rotateAnim.value)) / 2,
                          0,
                          -(widget.width * (1 - math.cos(rotateAnim.value))) /
                              2))
                    // ..translate(
                    //     -translateAnim.value, 0, -translateAnim.value))
                    : (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-rotateAnim.value)
                      ..scale(rotateAnim.value < math.pi / 4
                          ? firstScaleAnim.value
                          : lastScaleAnim.value)
                      ..translate(
                          translateAnim.value, 0, -translateAnim.value)),
                child: child,
              );
            },
            child: _wid1,
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext _, child) {
              return Transform(
                alignment: Alignment.center,
                transform: _turnNormal
                    ? (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      // ..scale(rotateAnim.value < math.pi / 4
                      //     ? firstScaleAnim.value
                      //     : lastScaleAnim.value)
                      ..rotateY(rotateAnim.value - math.pi / 2)
                      ..translate(widget.width - translateAnim.value, 0,
                          -widget.width + translateAnim.value))
                    : (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..scale(rotateAnim.value < math.pi / 4
                          ? firstScaleAnim.value
                          : lastScaleAnim.value)
                      ..rotateY(math.pi / 2 - rotateAnim.value)
                      ..translate(
                        translateAnim.value - widget.width,
                        0,
                        translateAnim.value - widget.width,
                      )),
                child: child,
              );
            },
            child: _wid2,
          ),
        ],
      ),
    );
  }

  void fromRight({Widget? widget}) {
    setState(() {
      if (widget == null) {
        try {
          widget = this
              .widget
              .contents!
              .elementAt(index % this.widget.contents!.length);
          index++;
        } catch (e) {
          widget = Container();
        }
      }
      _turnNormal = true;
      print(_turnNormal);
      print(index);
      if (_wid2 == _actual) _wid1 = _wid2;
      _wid2 = widget;
      _actual = _wid2;
      controller.reset();
      controller.forward();
    });
  }

  void fromLeft({Widget? widget}) {
    setState(() {
      if (widget == null) {
        try {
          widget = this
              .widget
              .contents!
              .elementAt(index % this.widget.contents!.length);
          index--;
        } catch (e) {
          widget = Container();
        }
      }
      _turnNormal = false;
      if (_wid2 == _actual) _wid2 = _wid1;
      _wid2 = widget;
      _actual = _wid2;
      controller.reset();
      controller.forward();
    });
  }
}
