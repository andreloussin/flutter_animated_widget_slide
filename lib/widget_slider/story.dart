import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/main.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';
import 'package:flutter_animated_widget_slide/widget_slider/diaporama.dart';
import 'package:flutter_animated_widget_slide/widget_slider/play_video.dart';

class StoryWidget extends StatefulWidget {
  final List<Widget> contents;
  final Function()? onDispose;
  const StoryWidget({Key? key, required this.contents, this.onDispose})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => StoryWidgetState();
}

class StoryWidgetState extends State<StoryWidget> {
  AnimatedWidgetSliderController controller = AnimatedWidgetSliderController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedWidgetSlider.builder(
        controller: controller,
        items: widget.contents,
        builder: (item, index) {
          item as Diaporama;
          if (index == 0) {
            item.setOnDiapoEnd(() {
              print("diapo end");
              controller.next();
            });
            item.setOnDiapoPrev(() {
              print("diapo prev with dispose");
              dispose();
            });
          } else if (index == widget.contents.length - 1) {
            item.setOnDiapoEnd(() {
              print("diapo prev with dispose");
              dispose();
            });
            item.setOnDiapoPrev(() {
              print("diapo prev");
              controller.prev();
            });
          } else {
            item.setOnDiapoEnd(() {
              print("diapo end");
              controller.next();
            });
            item.setOnDiapoPrev(() {
              print("diapo prev");
              controller.prev();
            });
          }

          return item;
        });
  }

  @override
  void dispose() {
    controller.dispose();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
    widget.onDispose!();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VideoPlayerScreen()));
  }
}
