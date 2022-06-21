import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter_animated_widget_slide/main.dart';

typedef AnimatedWidgetSliderBuilder = Widget? Function(Widget data, int index);
typedef AnimatedWidgetSliderScrollListener = Widget? Function(double level);

class AnimatedWidgetSlider extends StatefulWidget {
  AnimatedWidgetSliderController? controller;
  AnimatedWidgetSliderScrollListener? scrollListener;
  late AnimatedWidgetSliderState _bi;
  late List<Widget>? contents;
  bool startAutoScroll = false;

  AnimatedWidgetSlider(
      {Key? key,
      this.contents,
      this.scrollListener,
      this.controller,
      bool startAutoScroll = false})
      : super(key: key) {
    _bi = AnimatedWidgetSliderState(
        controller: controller,
        scrollListener: scrollListener,
        startAutoScroll: startAutoScroll);
  }

  static AnimatedWidgetSlider builder(
      {Key? key,
      required List<Widget> items,
      AnimatedWidgetSliderBuilder? builder,
      AnimatedWidgetSliderScrollListener? scrollListener,
      AnimatedWidgetSliderController? controller,
      bool startAutoScroll = false}) {
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
        controller: controller,
        scrollListener: scrollListener,
        startAutoScroll: startAutoScroll);
  }

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
  AnimatedWidgetSliderScrollListener? scrollListener;
  AnimatedWidgetSliderController? controller;
  late AnimationController animController;
  late Animation rotateAnim;
  late Animation translateAnim;
  late Animation firstScaleAnim;
  late Animation lastScaleAnim;
  final GlobalKey widgetKey = GlobalKey();
  bool _isPlaying = true;
  bool _turnNormal = true;
  bool autoNexting = false;
  bool startAutoScroll = false;
  int _waitSeconde = 2;
  int _tempWaitSeconde = 0;
  Widget? _actual;
  Widget? _hidden;
  Widget? _visible;
  int index = 0;
  double minScale = 0.8;
  double width = 0;

  AnimatedWidgetSliderState(
      {this.scrollListener, this.controller, this.startAutoScroll = false}) {
    controller?.setParent(this);
    scrollListener = scrollListener ?? (value) {};
  }

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Init Animations
    rotateAnim = Tween<double>(begin: 0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 1.0),
      ),
    );
    translateAnim = Tween<double>(begin: 0, end: width).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 1.0),
      ),
    );
    firstScaleAnim = Tween<double>(begin: 1, end: minScale).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.5),
      ),
    );
    lastScaleAnim = Tween<double>(begin: minScale, end: 1).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.5, 1.0),
      ),
    );

    // Set showing widget
    _hidden = widget.contents?.elementAt(index % widget.contents!.length);
    _actual = _hidden;

    WidgetsBinding.instance.addPostFrameCallback((data) {
      widthChanged();
      if (startAutoScroll) startAutoNexting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          autoNexting = false;
          if (details.velocity.pixelsPerSecond.dx > 0) {
            fromLeft();
          } else {
            fromRight();
          }
        },
        child: SizedBox.expand(
          child: Container(
            key: widgetKey,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: animController,
                    builder: (BuildContext _, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: _turnNormal
                            ? (Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(rotateAnim.value)
                              ..scale(scale_value())
                              ..translate(
                                  -(width * (1 - math.cos(rotateAnim.value))),
                                  rotateAnim.value > math.pi / 2 - math.pi / 12
                                      ? 10000
                                      : 0,
                                  -(width * math.sin(rotateAnim.value))))
                            : (Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(-rotateAnim.value)
                              ..scale(scale_value())
                              ..translate(
                                (width * (1 - math.cos(rotateAnim.value))),
                                rotateAnim.value > math.pi / 2 - math.pi / 12
                                    ? 10000
                                    : 0,
                                -(width * math.sin(rotateAnim.value)),
                              )),
                        child: child,
                      );
                    },
                    child: _hidden,
                  ),
                  AnimatedBuilder(
                    animation: animController,
                    builder: (BuildContext _, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: _turnNormal
                            ? (Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(rotateAnim.value - math.pi / 2)
                              ..scale(scale_value())
                              ..translate(
                                  width -
                                      (width * (math.sin(rotateAnim.value))),
                                  rotateAnim.value < math.pi / 12 ? 10000 : 0,
                                  -width +
                                      (width *
                                          (1 - math.cos(rotateAnim.value)))))
                            : (Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(math.pi / 2 - rotateAnim.value)
                              ..scale(scale_value())
                              ..translate(
                                (-width +
                                    (width * (math.sin(rotateAnim.value)))),
                                rotateAnim.value < math.pi / 12 ? 10000 : 0,
                                -width +
                                    (width * (1 - math.cos(rotateAnim.value))),
                              )),
                        child: child,
                      );
                    },
                    child: _visible,
                  ),
                ],
              ),
            ),
          ),
        ),
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
        parent: animController,
        curve: const Interval(0.0, 1.0),
      ),
    );
    translateAnim = Tween<double>(begin: 0, end: width).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 1.0),
      ),
    );
    firstScaleAnim = Tween<double>(begin: 1, end: minScale).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.5),
      ),
    );
    lastScaleAnim = Tween<double>(begin: minScale, end: 1).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.5, 1.0),
      ),
    );
  }

  void set tempWaitSeconde(int second) {
    _tempWaitSeconde = second;
  }

  void setTempWaitSecond(int second) {
    _tempWaitSeconde = second;
  }

  void setWaitSecond(int second) {
    _waitSeconde = second;
  }

  Future<void> startAutoNexting() async {
    while (autoNexting) {
      autoNexting = false;
      await Future.delayed(const Duration(milliseconds: 200));
    }
    play();
    autoNexting = true;
    int step = 0;
    while (autoNexting) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (step >=
          10 * (_tempWaitSeconde > 0 ? _tempWaitSeconde : _waitSeconde)) {
        _tempWaitSeconde = 0;
        step = 0;
        fromRight();
      }
      step += _isPlaying ? 1 : 0;
      scrollListener!(step /
          (10 * (_tempWaitSeconde > 0 ? _tempWaitSeconde : _waitSeconde)));
    }
  }

  void stopAutoNexting() {
    autoNexting = false;
  }

  void pause() {
    _isPlaying = false;
  }

  void play() {
    _isPlaying = true;
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
    setState(() {
      animController.reset();
      if (widget == null) {
        index++;
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
      animController.forward();
    });
  }

  void fromLeft({Widget? widget}) {
    setState(() {
      animController.reset();
      if (widget == null) {
        index--;
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
      animController.forward();
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

  void startAutoNexting() {
    parent!.startAutoNexting();
  }

  void stopAutoNexting() {
    parent!.stopAutoNexting();
  }

  void setTempWaitSecond(int second) {
    parent!.setTempWaitSecond(second);
  }

  void setWaitSecond(int second) {
    parent!.setWaitSecond(second);
  }

  void pause() {
    parent!.pause();
  }

  void play() {
    parent!.play();
  }

  bool isAutonexting() {
    // return AnimatedWidgetSliderState.autoNexting;
    return parent!.autoNexting;
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
