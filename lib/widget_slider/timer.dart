import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimerBar extends StatefulWidget {
  double step = 0.0;
  double Function(int index)? stepBuilder;
  int index = 0;
  late TimerBarState ts;
  final int number;
  TimerBar({super.key, this.number = 0}) {
    ts = TimerBarState(number: number);
  }

  void setStep(int index, double step) {
    this.index = index;
    this.step = step;
    ts.stepChange(index, step);
  }

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return ts;
  }
}

class TimerBarState extends State<TimerBar> {
  final int number;
  List<Widget> _timers = [];

  TimerBarState({this.number = 0});

  void stepChange(int index, double step) {
    setState(() {
      for (int i = 0; i < number; i++) {
        if (i < index) {
          (_timers.elementAt(2 * i + 1) as Timer).setStep(1);
        } else if (i == index) {
          (_timers.elementAt(2 * i + 1) as Timer).setStep(step);
        } else {
          (_timers.elementAt(2 * i + 1) as Timer).setStep(0);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Widget space = const SizedBox(width: 3);
    _timers = [space];

    for (int i = 0; i < number; i++) {
      _timers.add(Timer());
      _timers.add(space);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 5,
      child: Row(children: _timers),
    );
  }
}
//
//
//
//
//

// ignore: must_be_immutable
class Timer extends StatefulWidget {
  TimerState ts = TimerState();

  void setStep(double step) {
    ts.stepChange(step);
  }

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return ts;
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
                padding: EdgeInsets.only(right: width - ww),
                color: Colors.blue[50],
                child: Container(
                  color: Colors.blue,
                ))));
  }
}
