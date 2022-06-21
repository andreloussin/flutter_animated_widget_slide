import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/main.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';

class StoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {
  late Widget _widgetSlider;
  final GlobalKey _widgetKey = GlobalKey();
  Size size = const Size(0, 0);
  double step = 0;
  List<Widget> _timers = [];

  @override
  void initState() {
    super.initState();
    _widgetSlider = Container();
    Widget space = const SizedBox(width: 5);
    _timers = [
      space,
      Timer(step: 0.8),
      space,
      Timer.builder(() => 0.2),
      space,
      Timer.builder(() => 0.2),
      space,
      Timer.builder(() => 0.2),
      space,
      Timer.builder(() => 0.2),
      space,
      Timer.builder(() => 0.2),
      space,
      Timer.builder(() => 0.2),
      space,
      Timer.builder(() => 0.2),
      space,
    ];

    WidgetsBinding.instance.addPostFrameCallback((data) {
      size = (_widgetKey.currentContext?.findRenderObject() as RenderBox).size;
      setState(() {
        _widgetSlider = SizedBox(
          width: size.width,
          height: size.height - 65,
          child: AnimatedWidgetSlider(
            scrollListener: (data) {
              setState(() {
                step = data;
              });
            },
            contents: const [
              Text("AAAAA"),
              Text("BBBBB"),
              Text("CCCCC"),
              Text("DDDDD"),
              MyHomePage(title: 'a'),
              MyHomePage(title: 'b'),
              MyHomePage(title: 'c'),
              MyHomePage(title: 'd'),
            ],
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     color: Colors.white12,
    //     child: Column(
    //       children: [
    // Container(
    //   height: 5,
    //   color: Colors.red,
    // ),
    //         (Center(child: Text("Centered")))
    //         // Container(
    //         //   color: Colors.white,
    //         //   child:
    // AnimatedWidgetSlider(
    //         //     contents: [
    //         //       Text("AAAAA"),
    //         //       Text("BBBBB"),
    //         //       Text("CCCCC"),
    //         //       Text("DDDDD"),
    //         //       // MyHomePage(title: 'a'),
    //         //       // MyHomePage(title: 'b'),
    //         //       // MyHomePage(title: 'c'),
    //         //       // MyHomePage(title: 'd'),
    //         //     ],
    //         //   ),
    //         // ),
    //       ],
    //     ));
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
          color: Colors.red,
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
  double Function()? stepBuilder;
  Timer({super.key, double step = 0}) {
    this.step =
        0.0 <= step && step <= 1.0 ? step : throw "step must be in [0;1] ";
    stepBuilder = stepBuilder ?? () => step;
  }
  @override
  State<StatefulWidget> createState() {
    return TimerState();
  }

  static Timer builder(/** 0 <= step <= 1 */ double Function() stepBuilder) {
    return Timer(step: stepBuilder());
  }
}

class TimerState extends State<Timer> {
  double width = 0;
  final GlobalKey _widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((data) {
      setState(() {
        width = (_widgetKey.currentContext?.findRenderObject() as RenderBox)
            .size
            .width;
        print("new $width");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        key: _widgetKey,
        child: SizedBox.expand(
            child: Container(
                color: Colors.green[200],
                child: Center(
                    child: Container(
                        color: Colors.green,
                        width: width *
                            (0.0 <= widget.stepBuilder!() &&
                                    widget.stepBuilder!() <= 1.0
                                ? widget.stepBuilder!()
                                : throw "stepBuilder return must be in [0;1] "))))));
  }
}

class a extends Widget {
  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }
}
