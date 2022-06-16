import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter_animated_widget_slide/main.dart';

typedef AnimatedWidgetSliderBuilder = Widget? Function(Widget data, int index);

class AnimatedWidgetSlider extends StatefulWidget {
  late List<Widget>? contents;
  AnimatedWidgetSlider({Key? key, List<Widget>? contents}) : super(key: key) {
    this.contents = contents ??
        [
          const MyHomePage(title: "1"),
          const MyHomePage(title: "2"),
          const MyHomePage(title: "3"),
          const MyHomePage(title: "4"),
          const MyHomePage(title: "5"),
        ];
  }

  static AnimatedWidgetSlider builder(
      {Key? key,
      required List<Widget> items,
      AnimatedWidgetSliderBuilder? builder}) {
    builder = builder ?? (widget, index) => widget;
    List<Widget> li = [];
    if (items.isNotEmpty) {
      for (Widget item in items) {
        Widget? w = builder(item, items.indexOf(item));
        if (w != null) {
          li.add(Slide(widget: w));
        }
      }
    }
    return AnimatedWidgetSlider(
      key: key,
      contents: li,
    );
  }

  AnimatedWidgetSliderState _bi = AnimatedWidgetSliderState();

  @override
  State<StatefulWidget> createState() => _bi;

  void fromRight(Widget widget) {
    _bi.fromRight(widget: widget);
  }

  void fromLeft(Widget widget) {
    _bi.fromRight(widget: widget);
  }
}

class AnimatedWidgetSliderState extends State<AnimatedWidgetSlider>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation rotateAnim;
  late Animation translateAnim;
  late Animation firstScaleAnim;
  late Animation lastScaleAnim;
  final GlobalKey widgetKey = GlobalKey();
  bool _turnNormal = true;
  bool _autoNexting = false;
  int _waitSeconde = 2;
  int _tempWaitSeconde = 0;
  Widget? _actual;
  Widget? _hidden;
  Widget? _visible;
  int index = 0;
  double minScale = 0.7;
  double width = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Init Animations
    rotateAnim = Tween<double>(begin: 0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    translateAnim = Tween<double>(begin: 0, end: width).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    firstScaleAnim = Tween<double>(begin: 1, end: minScale).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5),
      ),
    );
    lastScaleAnim = Tween<double>(begin: minScale, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0),
      ),
    );

    // Set showing widget
    _hidden =
        this.widget.contents!.elementAt(index % this.widget.contents!.length);
    _actual = _hidden;

    WidgetsBinding.instance.addPostFrameCallback((data) {
      widthChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          _autoNexting = false;
          fromLeft();
        } else {
          fromRight();
        }
      },
      child: Stack(
        key: widgetKey,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext _, child) {
              return Transform(
                alignment: Alignment.center,
                transform: _turnNormal
                    ? (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(rotateAnim.value)
                      ..scale(scale_value())
                      ..translate(-(width * (1 - math.cos(rotateAnim.value))),
                          0, -(width * math.sin(rotateAnim.value))))
                    : (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-rotateAnim.value)
                      ..scale(scale_value())
                      ..translate((width * (1 - math.cos(rotateAnim.value))), 0,
                          -(width * math.sin(rotateAnim.value)))),
                child: child,
              );
            },
            child: rotateAnim.value < math.pi / 4
                ? _turnNormal
                    ? _hidden
                    : _visible
                : _turnNormal
                    ? _visible
                    : _hidden,
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext _, child) {
              return Transform(
                alignment: Alignment.center,
                transform: _turnNormal
                    ? (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(rotateAnim.value - math.pi / 2)
                      ..scale(scale_value())
                      ..translate(
                          width - (width * (math.sin(rotateAnim.value))),
                          0,
                          -width + (width * (1 - math.cos(rotateAnim.value)))))
                    : (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi / 2 - rotateAnim.value)
                      ..scale(scale_value())
                      ..translate(
                        (-width + (width * (math.sin(rotateAnim.value)))),
                        0,
                        -width + (width * (1 - math.cos(rotateAnim.value))),
                      )),
                child: child,
              );
            },
            child: rotateAnim.value < math.pi / 4
                ? _turnNormal
                    ? _visible
                    : _hidden
                : _turnNormal
                    ? _hidden
                    : _visible,
          ),
        ],
      ),
    );
  }

  void widthChanged() {
    // Get widget width after render
    width =
        (widgetKey.currentContext?.findRenderObject() as RenderBox).size.width /
            2;

    // Reinit Animations
    rotateAnim = Tween<double>(begin: 0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    translateAnim = Tween<double>(begin: 0, end: width).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    firstScaleAnim = Tween<double>(begin: 1, end: minScale).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5),
      ),
    );
    lastScaleAnim = Tween<double>(begin: minScale, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0),
      ),
    );
    setState(() {});
  }

  void set tempWaitSeconde(int second) {
    _tempWaitSeconde = second;
  }

  void setTempWaitSecond(int second) {
    _tempWaitSeconde = second;
  }

  Future<void> startAutoNexting() async {
    _autoNexting = true;
    int step = 0;
    while (_autoNexting) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (step >=
          10 * (_tempWaitSeconde > 0 ? _tempWaitSeconde : _waitSeconde)) {
        _tempWaitSeconde = 0;
        step = 0;
        fromRight();
      }
      step++;
    }
  }

  void stopAutoNexting() {
    _autoNexting = false;
  }

  double scale_value() {
    return rotateAnim.value < math.pi / 4
        ? firstScaleAnim.value
        : lastScaleAnim.value;
  }

  double rotate_degree() {
    return rotateAnim.value < math.pi / 4
        ? firstScaleAnim.value
        : lastScaleAnim.value;
  }

  void fromRight({Widget? widget}) {
    print("fromRight");
    setState(() {
      controller.reset();
    });
    setState(() {
      if (widget == null) {
        index++;
        print(index);
        try {
          widget = this
              .widget
              .contents!
              .elementAt(index % this.widget.contents!.length);
        } catch (e) {
          widget = Container();
        }
      }
      if (_actual != _hidden) {
        _hidden = _visible;
      }
      _visible = widget;
      _turnNormal = true;
      _actual = _visible;
      controller.forward();
    });
  }

  void fromLeft({Widget? widget}) {
    print("fromLeft");
    setState(() {
      controller.reset();
    });
    setState(() {
      if (widget == null) {
        index--;
        print(index);
        try {
          widget = this
              .widget
              .contents!
              .elementAt(index % this.widget.contents!.length);
        } catch (e) {
          widget = Container();
        }
      }
      if (_actual != _visible) {
        _visible = _hidden;
      }
      _hidden = widget;
      _turnNormal = false;
      _actual = _hidden;
      controller.forward();
    });
  }
}

class AnimatedWidgetSliderController {
  AnimatedWidgetSliderState? parent;

  void setParent(AnimatedWidgetSliderState parent) {
    this.parent = parent;
  }

  void next() {
    parent!.fromRight();
  }

  void prev() {
    parent!.fromLeft();
  }

  void startAutoNextiong() {
    parent!.startAutoNexting();
  }

  void stopAutoNextiong() {
    parent!.stopAutoNexting();
  }
}

class Slide extends StatelessWidget {
  final Widget? widget;

  const Slide({super.key, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget,
    );
  }
}
