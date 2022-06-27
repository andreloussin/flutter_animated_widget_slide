import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animated_widget_slide/widget_slider/diaporamaShow.dart';
import 'package:flutter_animated_widget_slide/widget_slider/timer.dart';

class Diaporama extends StatefulWidget {
  final List<Widget> stories;
  DiaporamaShowController? controller;
  DiaporamaState st = DiaporamaState();

  Diaporama({
    super.key,
    this.stories = const [],
    DiaporamaShowController? controller,
  }) {
    this.controller = controller ?? DiaporamaShowController();
  }
  @override
  DiaporamaState createState() {
    return st;
  }

  void setOnDiapoEnd(void Function() onDiapoEnd) {
    st.setOnDiapoEnd(onDiapoEnd);
  }

  void setOnDiapoPrev(void Function() onDiapoPrev) {
    st.setOnDiapoPrev(onDiapoPrev);
  }

  void pause() {
    controller!.pause();
  }

  void play() {
    controller!.play();
  }
}

class DiaporamaState extends State<Diaporama> {
  late DiaporamaShow diapo;
  late TimerBar timerBar;
  late Widget diaposContainer;
  Key key = Key("DiaporamaState${Random().nextInt(1000)}");
  final GlobalKey _widgetKey = GlobalKey();
  Size size = const Size(0, 0);
  bool initialized = false;
  List<Function()> onInstanciatedCallback = [];

  void setOnDiapoEnd(void Function() onDiapoEnd) {
    {
      onInstanciatedCallback.add(() {
        diapo.onDiapoEnd = onDiapoEnd;
      });
    }
  }

  void setOnDiapoPrev(void Function() onDiapoPrev) {
    {
      onInstanciatedCallback.add(() {
        diapo.onDiapoEnd = onDiapoPrev;
      });
    }
  }

  void runCallbacks() async {
    for (Function() callback in onInstanciatedCallback) {
      try {
        callback();
      } catch (e) {
        print("error when runnin this callback: $callback");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    diaposContainer = Container();
    timerBar = TimerBar(number: widget.stories.length);
    diapo = DiaporamaShow.builder(
        controller: widget.controller!,
        items: widget.stories,
        startAutoScroll: true,
        stepListener: timerBar.setStep);
    WidgetsBinding.instance.addPostFrameCallback((data) {
      size = (_widgetKey.currentContext?.findRenderObject() as RenderBox).size;
      runCallbacks();
      setState(() {
        diaposContainer = SizedBox(
          width: size.width,
          height: size.height - 65,
          child: diapo,
        );
      });
      runCallbacks();
    });
    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return SizedBox.expand(
        key: _widgetKey,
        child: Column(
          children: [
            timerBar,
            diaposContainer,
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
