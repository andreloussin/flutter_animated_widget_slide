import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/main.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';

class StoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              height: 5,
              color: Colors.red,
            ),
            Container(
              color: Colors.black12,
              child: AnimatedWidgetSlider(
                contents: [
                  MyHomePage(title: 'a'),
                  MyHomePage(title: 'b'),
                  MyHomePage(title: 'c'),
                  MyHomePage(title: 'd'),
                ],
              ),
            ),
          ],
        ));
  }
}
