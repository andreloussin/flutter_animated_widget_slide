import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';

class StoryPage extends StatefulWidget {
  final List<Widget> contents;
  StoryPage({Key? key, required this.contents}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {
  late Widget _widgetSlider;
  final GlobalKey _widgetKey = GlobalKey();
  Size size = const Size(0, 0);
  double step = 0;
  int scrollingIndex = 0;
  List<Widget> _timers = [];
  AnimatedWidgetSliderController controller = AnimatedWidgetSliderController();

  double makeStep(int index, int timerIndex) {
    return timerIndex < index
        ? 1.0
        : timerIndex == index
            ? step
            : 0.0;
  }

  @override
  void initState() {
    super.initState();
    _widgetSlider = Container();
    Widget space = const SizedBox(width: 5);
    _timers = [space];

    for (int i = 0; i < widget.contents.length; i++) {
      _timers.add(Timer());
      _timers.add(space);
    }

    WidgetsBinding.instance.addPostFrameCallback((data) {
      size = (_widgetKey.currentContext?.findRenderObject() as RenderBox).size;
      setState(() {
        _widgetSlider = SizedBox(
          width: size.width,
          height: size.height - 65,
          child: AnimatedWidgetSlider(
            startAutoScroll: true,
            controller: controller,
            scrollListener: (data, index) {
              setState(() {
                for (int i = 0; i < widget.contents.length; i++) {
                  if (i < index) {
                    (_timers.elementAt(2 * i + 1) as Timer).setStep(1);
                  } else if (i == index) {
                    (_timers.elementAt(2 * i + 1) as Timer).setStep(data);
                  } else {
                    (_timers.elementAt(2 * i + 1) as Timer).setStep(0);
                  }
                  step = data;
                }
                scrollingIndex = index;
              });
            },
            contents: widget.contents,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Column(
      key: _widgetKey,
      children: [
        // Container(
        //   height: 10,
        // ),
        Container(
          alignment: Alignment.centerLeft,
          height: 5,
          width: size.width,
          child: Row(children: _timers),
        ),
        _widgetSlider,
        Container(
            height: 50,
            color: Colors.green[400],
            child: const Center(
              child: Text("Auto Scrolling"),
            )),
        Container(
          height: 10,
        ),
      ],
    ));
  }
}

class Timer extends StatefulWidget {
  double step = 0;
  double Function(int index)? stepBuilder;
  final int index;
  Timer(
      {super.key,
      double step = 0.0,
      this.index = 0,
      double Function(int index)? stepBuilder}) {
    this.step =
        0.0 <= step && step <= 1.0 ? step : throw "step must be in [0;1] ";
    this.stepBuilder = stepBuilder ?? (index) => step;
  }

  TimerState _ts = TimerState();

  void setStep(double step) {
    this.step = step;
    _ts.stepChange(step);
  }

  @override
  State<StatefulWidget> createState() {
    return _ts;
  }

  static Timer builder(
      {int index = 0,
      /** 0 <= step <= 1 */ required double Function(int index) stepBuilder}) {
    return Timer(
      index: index,
      step: stepBuilder(index),
      stepBuilder: stepBuilder,
    );
  }
}

class TimerState extends State<Timer> {
  double width = 0.0;
  double ww = 0;
  final GlobalKey _widgetKey = GlobalKey();

  void stepChange(double step) {
    setState(() {
      ww = setStep(step);
    });
  }

  double setStep(double step) {
    if (width == 0.0) {
      width = (_widgetKey.currentContext?.findRenderObject() as RenderBox)
          .size
          .width;
    }
    return width *
        (0.0 <= step && step <= 1.0
            ? step
            : throw "stepBuilder return must be in [0;1] ");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox.expand(
            child: Container(
                key: _widgetKey,
                color: Colors.blue[50],
                child: Center(
                    child: Container(
                  color: Colors.blue,
                  width: ww,
                )))));
  }
}
