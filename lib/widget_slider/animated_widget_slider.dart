import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_animated_widget_slide/main.dart';

class AnimatedWidgetSlider extends StatefulWidget {
  final double width;
  late final Widget? initial;
  late final List<Widget>? contents;
  AnimatedWidgetSlider(
      {Key? key, required this.width, this.initial, this.contents})
      : super(key: key);
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
  late Animation anim1;
  late Animation anim2;
  late Animation anim3;
  late Animation anim4;
  final GlobalKey _widgetKey = GlobalKey();
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
      duration: const Duration(milliseconds: 500),
    );
    anim1 = Tween<double>(begin: 0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    anim2 = Tween<double>(begin: 0, end: widget.width).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    anim3 = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5),
      ),
    );
    anim4 = Tween<double>(begin: 0.9, end: 1).animate(
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
      onPanUpdate: (details) {
        if (details.delta.dx > 0)
          fromLeft(widget: MyHomePage(title: "LEFT"));
        else
          fromRight(widget: MyHomePage(title: "RIGHT"));
      },
      child: Stack(
        key: _widgetKey,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext _, child) {
              // Offset _offset = Offset(0, anim1.value);
              return Transform(
                alignment: Alignment.center,
                transform: _turnNormal
                    ? (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(anim1.value)
                      ..scale(anim3.value)
                      ..scale(anim4.value)
                      ..translate(-anim2.value, 0, -anim2.value))
                    : (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-anim1.value)
                      ..scale(anim3.value)
                      ..scale(anim4.value)
                      ..translate(anim2.value, 0, -anim2.value)),
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
                      ..scale(anim3.value)
                      ..scale(anim4.value)
                      ..rotateY(anim1.value - math.pi / 2)
                      ..translate(widget.width - anim2.value, 0,
                          -widget.width + anim2.value))
                    : (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..scale(anim3.value)
                      ..scale(anim4.value)
                      ..rotateY(math.pi / 2 - anim1.value)
                      ..translate(
                        anim2.value - widget.width,
                        0,
                        anim2.value - widget.width,
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
    widget ??= Container();
    setState(() {
      _turnNormal = true;
      if (_wid2 == _actual) _wid1 = _wid2;
      _wid2 = widget;
      _actual = _wid2;
      controller.reset();
      controller.forward();
    });
  }

  void fromLeft({Widget? widget}) {
    widget ??= Container();
    setState(() {
      _turnNormal = false;
      if (_wid2 == _actual) _wid2 = _wid1;
      _wid2 = widget;
      _actual = _wid2;
      controller.reset();
      controller.forward();
    });
  }
}
