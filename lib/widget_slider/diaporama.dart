import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animated_widget_slide/widget_slider/diaporamaShow.dart';
import 'package:flutter_animated_widget_slide/widget_slider/timer.dart';

class Diaporama extends StatefulWidget {
  final List<Widget> stories;
  DiaporamaShowController? controller;
  DiaporamaState st = DiaporamaState();
  Function()? onDiapoEnd;
  Function()? onDiapoPrev;

  Diaporama(
      {super.key,
      this.stories = const [],
      DiaporamaShowController? controller,
      this.onDiapoEnd,
      this.onDiapoPrev}) {
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

  void setOnDiapoEnd(void Function() onDiapoEnd) {
    if (initialized) {
      widget.onDiapoEnd = onDiapoEnd;
      diapo.onDiapoEnd = widget.onDiapoEnd;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((data) {
        widget.onDiapoEnd = onDiapoEnd;
        diapo.onDiapoEnd = widget.onDiapoEnd;
      });
    }
  }

  void setOnDiapoPrev(void Function() onDiapoPrev) {
    if (initialized) {
      widget.onDiapoPrev = onDiapoPrev;
      diapo.onDiapoPrev = widget.onDiapoPrev;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((data) {
        widget.onDiapoPrev = onDiapoPrev;
        diapo.onDiapoPrev = widget.onDiapoPrev;
      });
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
      setState(() {
        diaposContainer = SizedBox(
          width: size.width,
          height: size.height - 65,
          child: diapo,
        );
      });

      diapo.onDiapoEnd = widget.onDiapoEnd;
      diapo.onDiapoPrev = widget.onDiapoPrev;
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
