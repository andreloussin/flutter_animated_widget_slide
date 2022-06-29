import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_widget_slide/Slide/text_slide.dart';
import 'package:flutter_animated_widget_slide/Slide/video_slide.dart';
import 'package:flutter_animated_widget_slide/stream_video/stream_video_component.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';
import 'package:flutter_animated_widget_slide/widget_slider/p_story.dart';
import 'package:flutter_animated_widget_slide/widget_slider/play_video.dart';
import 'package:flutter_animated_widget_slide/widget_slider/diaporama.dart';
import 'package:flutter_animated_widget_slide/widget_slider/story.dart';
import 'package:flutter_animated_widget_slide/widget_slider/w_story_cubic_animated.dart';

void main() {
  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("diamond ring")),
          // body: StreamVideoPlayer(link: ""),
          body: TextSlide(
              "this is some text with @tag and link @blur www.facebook.com or https://freebasics.com"))));
}

void maine() {
  List<Widget> ws = const [
    Text("AAAAA"),
    Text("BBBBB"),
    Text("CCCCC"),
    Text("DDDDD"),
    Text("EEEEE"),
  ];
  int index = 0;
  StoryCubicAnimatedController ctrl = StoryCubicAnimatedController();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: StoryCubicAnimated(
          initial: ws[index],
          controller: ctrl,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            index = (index - 1) % ws.length;
            ctrl.prev(ws[index]);
            print("Prev");
          },
          tooltip: 'Prev',
          child: const Icon(Icons.skip_previous_outlined),
        ),
      ),
    ),
  );
}

void mainww() {
  List<Diaporama> diaps = [
    Diaporama(
      stories: [
        VideoSlide(),
        TextSlide(
            "this is some text with @tag and link @blur www.facebook.com or https://freebasics.com"),
        // StreamVideoPlayer(),
        Text("AAAAA"),
        MyHomePage(title: 'a'),
        Text("AAAAA"),
        MyHomePage(title: 'a'),
        MyHomePage(title: 'b'),
      ],
    ),
    Diaporama(
      stories: const [
        MyHomePage(title: 'a'),
        // Text("AAAAA"),
        MyHomePage(title: 'ab'),
      ],
    ),
    Diaporama(
      stories: const [
        MyHomePage(title: 'a'),
        Text("AAAAA"),
        MyHomePage(title: 'ab'),
      ],
    ),
    Diaporama(
      stories: [
        VideoSlide(),
        StreamVideoPlayer(),
        TextSlide(
            "this is some text with @tag and link @blur www.facebook.com or https://freebasics.com"),
        MyHomePage(title: 'b'),
      ],
    ),
    Diaporama(
      stories: const [
        MyHomePage(title: 'a'),
        Text("AAAAA"),
        MyHomePage(title: 'ab'),
      ],
    ),
  ];
  runApp(
    const MaterialApp(
      title: "ece",
      // home: StoryWidget(contents: diaps),
      home: Bibi(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Bibi extends StatefulWidget {
  const Bibi({Key? key}) : super(key: key);

  @override
  State<Bibi> createState() => _BibiState();
}

class _BibiState extends State<Bibi> {
  final AnimatedWidgetSlider _w = AnimatedWidgetSlider(
    contents: const [
      MyHomePage(title: 'a'),
      MyHomePage(title: 'b'),
      MyHomePage(title: 'c'),
      MyHomePage(title: 'd'),
      MyHomePage(title: 'e'),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _w,
          // ElevatedButton(onPressed: () {}, child: const Text("Left")),
          // ElevatedButton(onPressed: () {}, child: const Text("Right")),
        ],
      ),
    );
  }
}
