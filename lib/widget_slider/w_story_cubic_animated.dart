import 'package:flutter/material.dart';
import 'dart:math' as math;

class StoryCubicAnimated extends StatefulWidget {
  final Widget initial;
  final double minScale;
  final int animMilliseconds;
  final StoryCubicAnimatedController? controller;
  const StoryCubicAnimated(
      {Key? key,
      required this.initial,
      this.minScale = 0.8,
      this.animMilliseconds = 2000,
      this.controller})
      : super(key: key);

  @override
  StoryCubicAnimatedState createState() => StoryCubicAnimatedState();
}

class StoryCubicAnimatedState extends State<StoryCubicAnimated>
    with TickerProviderStateMixin {
  Widget? _showing;
  Widget? _nexting;
  Widget? _showingWidget;
  Widget? _nextingWidget;
  final GlobalKey<StoryCubicAnimatedState> _widgetKey = GlobalKey();
  double width = 0.0;

  late AnimationController _animController;
  late Animation _rotationAnim;
  // late Animation _translationAnim;
  late Animation _scaleUpAnim;
  late Animation _scaleDownAnim;
  late Matrix4 _frontToLeftTransform = Matrix4.identity();
  late Matrix4 _frontToRightTransform = Matrix4.identity();
  late Matrix4 _leftToFrontTransform = Matrix4.identity();
  late Matrix4 _rightToFrontTransform = Matrix4.identity();

  @override
  void initState() {
    super.initState();

    // Init Controllers
    try {
      widget.controller?.setParent(this);
    } catch (e) {/**/}
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animMilliseconds),
    );

    // Init viewport
    _showing = widget.initial;
    _showingWidget = AnimatedBuilder(
        animation: _animController,
        builder: (BuildContext _, wid) {
          return Transform(
            alignment: Alignment.center,
            transform: _frontToLeftTransform,
            child: wid,
          );
        },
        child: _showing);
    // _showingWidget = _showing;

    WidgetsBinding.instance.addPostFrameCallback((data) {
      loadWidth();

      // Init animations using new width value
      _rotationAnim = Tween<double>(begin: 0, end: math.pi / 2).animate(
        CurvedAnimation(
          parent: _animController,
          curve: const Interval(0.0, 1.0),
        ),
      );
      // _translationAnim = Tween<double>(begin: 0, end: width / 2).animate(
      //   CurvedAnimation(
      //     parent: _animController,
      //     curve: const Interval(0.0, 1.0),
      //   ),
      // );
      _scaleUpAnim = Tween<double>(begin: 1, end: widget.minScale).animate(
        CurvedAnimation(
          parent: _animController,
          curve: const Interval(0.0, 0.5),
        ),
      );
      _scaleDownAnim = Tween<double>(begin: widget.minScale, end: 1).animate(
        CurvedAnimation(
          parent: _animController,
          curve: const Interval(0.5, 1.0),
        ),
      );

      // Init Transforms with animations
      _frontToLeftTransform = Matrix4.identity()
        ..rotateY(_rotationAnim.value)
        ..scale(scaleValue())
        ..translate(
            -(width * (1 - math.cos(_rotationAnim.value))),
            // Avoid widget Mix
            _rotationAnim.value > math.pi / 2 - math.pi / 12 ? 10000 : 0,
            -(width * math.sin(_rotationAnim.value)));

      _frontToRightTransform = Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(-_rotationAnim.value)
        ..scale(scaleValue())
        ..translate(
            (width * (1 - math.cos(_rotationAnim.value))),
            // Avoid widget Mix
            _rotationAnim.value > math.pi / 2 - math.pi / 12 ? 10000 : 0,
            -(width * math.sin(_rotationAnim.value)));

      _leftToFrontTransform = Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(math.pi / 2 - _rotationAnim.value)
        ..scale(scaleValue())
        ..translate(
            (-width + (width * (math.sin(_rotationAnim.value)))),
            // Avoid widget Mix
            _rotationAnim.value < math.pi / 12 ? 10000 : 0,
            -width + (width * (1 - math.cos(_rotationAnim.value))));

      _rightToFrontTransform = Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(_rotationAnim.value - math.pi / 2)
        ..scale(scaleValue())
        ..translate(
            width - (width * (math.sin(_rotationAnim.value))),
            // Avoid widget Mix
            _rotationAnim.value < math.pi / 12 ? 10000 : 0,
            -width + (width * (1 - math.cos(_rotationAnim.value))));

      print("All Fields are reinitialized");
    });
  }

  void loadWidth() {
    try {
      width = (_widgetKey.currentContext?.findRenderObject() as RenderBox)
              .size
              .width /
          2;
    } catch (e) {
      width = 0.0;
    }
    print("width: $width");
  }

  resetWidgetPosition() {
    while (_animController.isAnimating) {
      print(" Wait until animation finishes");
    }
    if (_animController.isCompleted) {}
    setState(() {
      _showing = _nexting;
      _nextingWidget = null;
    });
    _animController.reset();
    print("widgets reseted");
  }

  void next(Widget nexting) {
    setState(() {
      _nexting = nexting;
      _nextingWidget = AnimatedBuilder(
        animation: _animController,
        builder: (BuildContext _, wid) {
          return Transform(
            alignment: Alignment.center,
            transform: _rightToFrontTransform,
            child: wid,
          );
        },
        child: _nexting,
      );
      _showingWidget = AnimatedBuilder(
        animation: _animController,
        builder: (BuildContext _, wid) {
          return Transform(
            alignment: Alignment.center,
            transform: _frontToLeftTransform,
            child: wid,
          );
        },
        child: _showing,
      );
      print(
          "_nexting: $_nexting &&  _showing: $_showing && _showingWidget: ${_showingWidget}");
    });
    _animController.forward();
    //resetWidgetPosition();
  }

  void prev(Widget nexting) {
    _nexting = nexting;
    _nextingWidget = AnimatedBuilder(
      animation: _animController,
      builder: (BuildContext _, wid) {
        return Transform(
          alignment: Alignment.center,
          transform: _leftToFrontTransform,
          child: wid,
        );
      },
      child: _nexting,
    );
    _showingWidget = AnimatedBuilder(
      animation: _animController,
      builder: (BuildContext _, wid) {
        return Transform(
          alignment: Alignment.center,
          transform: _frontToRightTransform,
          child: wid,
        );
      },
      child: _showing,
    );
    _animController.forward();
    //resetWidgetPosition();
  }

  double scaleValue() {
    return _rotationAnim.value < math.pi / 4
        ? _scaleDownAnim.value
        : _scaleUpAnim.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox.expand(
        child: Stack(
          key: _widgetKey,
          alignment: Alignment.center,
          children: [
            _showingWidget ?? Container(),
            _nextingWidget ?? Container(),
          ],
        ),
      ),
    );
  }
}

class StoryCubicAnimatedController {
  late final StoryCubicAnimatedState _parent;

  void setParent(StoryCubicAnimatedState parent) {
    _parent = parent;
  }

  void next(Widget nexting) {
    print("_parent.next(nexting)");
    _parent.next(nexting);
  }

  void prev(Widget nexting) {
    _parent.prev(nexting);
  }
}
