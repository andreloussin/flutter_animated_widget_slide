import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_widget_slide/main.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';

class Test extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TestState();
  }
}

class TestState extends State<Test> {
  AnimatedWidgetSliderController controller = AnimatedWidgetSliderController();
  int indexed = 0;
  bool _isPlaying = true;

  TestState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test widget")),
      body: Container(
        color: Colors.black12,
        child: AnimatedWidgetSlider(
          controller: controller,
          contents: [
            MyHomePage(title: 'a'),
            MyHomePage(title: 'b'),
            MyHomePage(title: 'c'),
            MyHomePage(title: 'd'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexed,
        fixedColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(255, 179, 179, 179),
              label: "Preview",
              icon: Icon(Icons.preview)),
          BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(255, 179, 179, 179),
              label: "Auto Scroll",
              icon: Icon(Icons.loop)),
          BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(255, 179, 179, 179),
              label: "Next",
              icon: Icon(Icons.next_plan)),
          BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(255, 179, 179, 179),
              label: _isPlaying ? "Pause" : "PLay",
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow_outlined)),
        ],
        onTap: (index) {
          indexed = index;
          switch (index) {
            case 0:
              controller.prev();
              break;
            case 1:
              controller.isAutonexting()
                  ? controller.stopAutoNexting()
                  : controller.startAutoNexting();
              break;
            case 2:
              controller.next();
              break;
            case 3:
              _isPlaying ? controller.pause() : controller.play();
              _isPlaying = !_isPlaying;

              // showGeneralDialog(
              //     context: context,
              //     barrierDismissible: true,
              //     barrierLabel: MaterialLocalizations.of(context)
              //         .modalBarrierDismissLabel,
              //     barrierColor: Colors.black45,
              //     transitionDuration: const Duration(milliseconds: 200),
              //     pageBuilder: (context, anim1, anim2) {
              //       return Center(
              //         child: Container(
              //           width: MediaQuery.of(context).size.width - 10,
              //           height: MediaQuery.of(context).size.height - 80,
              //           padding: EdgeInsets.all(20),
              //           color: Colors.white,
              //           child: Column(
              //             children: [
              //               Text("Set number of second of the "),
              //               // TextFormField(
              //               //   keyboardType: TextInputType.number,
              //               // ),
              //               ElevatedButton(
              //                 onPressed: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Text(
              //                   "global annimation",
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //               ),
              //               ElevatedButton(
              //                 onPressed: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Text(
              //                   "next animation",
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //               ),
              //               ElevatedButton(
              //                 onPressed: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Text(
              //                   "Cancel",
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     });
              break;
            default:
          }
        },
      ),
    );
  }
}
