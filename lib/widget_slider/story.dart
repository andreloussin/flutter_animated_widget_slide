import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';
import 'package:flutter_animated_widget_slide/widget_slider/diaporama.dart';

class StoryWidget extends StatefulWidget {
  final List<Widget> contents;
  StoryWidget({Key? key, required this.contents}) : super(key: key);

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
          // item.setOnDiapoEnd(() {
          //   controller.next();
          // });
          // item.setOnDiapoPrev(() {
          //   controller.next();
          // });
          return item;
        });
  }
}
