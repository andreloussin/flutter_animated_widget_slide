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
  final GlobalKey<StoryCubicAnimatedState> _widgetKey = GlobalKey();
  double width = 0.0;
  bool _toNext = true;

  late AnimationController _animController;
  late Animation _rotationAnim;
  // late Animation _translationAnim;
  late Animation _scaleUpAnim;
  late Animation _scaleDownAnim;

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

    // Init animations
    _rotationAnim = Tween<double>(begin: 0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 1.0),
      ),
    );
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

    // Init viewport
    _showing = widget.initial;
    // _showingWidget = _showing;

    WidgetsBinding.instance.addPostFrameCallback((data) {
      loadWidth();
    });
  }

  void loadWidth() {
    setState(() {
      try {
        width = (_widgetKey.currentContext?.findRenderObject() as RenderBox)
                .size
                .width /
            2;
      } catch (e) {
        width = 0.0;
      }
    });
  }

  resetWidgetPosition() {
    setState(() {
      Future.delayed(Duration(milliseconds: widget.animMilliseconds));
      _animController.reset();
      _showing = _nexting;
      _animController.reset();
    });
    setState(() {});
  }

  void next(Widget nexting) {
    if (!_animController.isAnimating) {
      setState(() {
        _toNext = true;
        _nexting = _showing;
        _showing = nexting;
        if (_animController.isCompleted) _animController.reset();
        _animController.forward();
      });
    }
  }

  void prev(Widget nexting) {
    if (!_animController.isAnimating) {
      setState(() {
        _toNext = false;
        _nexting = _showing;
        _showing = nexting;
        if (_animController.isCompleted) _animController.reset();
        _animController.forward();
      });
    }
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
            AnimatedBuilder(
              animation: _animController,
              builder: (BuildContext _, wid) {
                return Transform(
                  alignment: Alignment.center,
                  transform: _toNext
                      ?
                      // Front to Left
                      (Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_rotationAnim.value)
                        ..scale(scaleValue())
                        ..translate(
                            -(width * (1 - math.cos(_rotationAnim.value))),
                            _rotationAnim.value > math.pi / 2 - math.pi / 12
                                ? 10000
                                : 0,
                            -(width * math.sin(_rotationAnim.value))))
                      :
                      // Front to Right
                      (Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(-_rotationAnim.value)
                        ..scale(scaleValue())
                        ..translate(
                          (width * (1 - math.cos(_rotationAnim.value))),
                          _rotationAnim.value > math.pi / 2 - math.pi / 12
                              ? 10000
                              : 0,
                          -(width * math.sin(_rotationAnim.value)),
                        )),
                  child: wid,
                );
              },
              child: _nexting,
            ),
            AnimatedBuilder(
              animation: _animController,
              builder: (BuildContext _, wid) {
                return Transform(
                  alignment: Alignment.center,
                  transform: _toNext
                      ?
                      // Right to Front
                      (Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_rotationAnim.value - math.pi / 2)
                        ..scale(scaleValue())
                        ..translate(
                            width - (width * (math.sin(_rotationAnim.value))),
                            _rotationAnim.value < math.pi / 12 ? 10000 : 0,
                            -width +
                                (width * (1 - math.cos(_rotationAnim.value)))))
                      :
                      // Right to Front
                      (Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(math.pi / 2 - _rotationAnim.value)
                        ..scale(scaleValue())
                        ..translate(
                          (-width + (width * (math.sin(_rotationAnim.value)))),
                          _rotationAnim.value < math.pi / 12 ? 10000 : 0,
                          -width +
                              (width * (1 - math.cos(_rotationAnim.value))),
                        )),
                  child: wid,
                );
              },
              child: _showing,
            ),
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
    _parent.next(nexting);
  }

  void prev(Widget nexting) {
    _parent.prev(nexting);
  }
}
