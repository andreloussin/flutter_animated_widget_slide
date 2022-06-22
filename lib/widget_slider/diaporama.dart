import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/widget_slider/diaporamaShow.dart';
import 'package:flutter_animated_widget_slide/widget_slider/timer.dart';

class Diaporama extends StatefulWidget {
  final List<Widget> stories;
  DiaporamaShowController? controller;
  DiaporamaState st = DiaporamaState();

  Diaporama({super.key, this.stories = const [], this.controller}) {}
  @override
  DiaporamaState createState() {
    return st;
  }

  void setOnDiapoEnd(void Function() onDiapoEnd) {
    st.setOnDiapoEnd(onDiapoEnd);
  }

  void setOnDiapoPrev(void Function() onDiapoPrev) {
    st.setOnDiapoEnd(onDiapoPrev);
  }
}

class DiaporamaState extends State<Diaporama> {
  late DiaporamaShow diapo;
  late TimerBar timerBar;
  late Widget diaposContainer;
  final GlobalKey _widgetKey = GlobalKey();
  Size size = const Size(0, 0);

  void setOnDiapoEnd(void Function() onDiapoEnd) {
    diapo.onDiapoEnd = onDiapoEnd;
  }

  void setOnDiapoPrev(void Function() onDiapoPrev) {
    diapo.onDiapoPrev = onDiapoPrev;
  }

  @override
  void initState() {
    super.initState();
    diaposContainer = Container();
    timerBar = TimerBar(number: widget.stories.length);
    diapo = DiaporamaShow.builder(
        controller: widget.controller,
        items: widget.stories,
        startAutoScroll: true,
        stepListener: timerBar?.setStep);
    WidgetsBinding.instance.addPostFrameCallback((data) {
      size = (_widgetKey.currentContext?.findRenderObject() as RenderBox).size;
      setState(() {
        diaposContainer = SizedBox(
          width: size.width,
          height: size.height - 65,
          child: diapo,
        );
      });
    });
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

// class DiaporamaController {
//   DiaporamaState? parent;
//   setParent(DiaporamaState? parent) {
//     this.parent = parent;
//   }

//   void setOnDiapoEnd(void Function() onDiapoEnd) {
//     parent!.setOnDiapoEnd(onDiapoEnd);
//   }

//   void setOnDiapoPrev(void Function() onDiapoPrev) {
//     parent!.setOnDiapoEnd(onDiapoPrev);
//   }
// }
