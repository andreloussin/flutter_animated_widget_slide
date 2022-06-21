import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/test.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';
import 'package:flutter_animated_widget_slide/widget_slider/p_story.dart';

void main() {
  runApp(
    MaterialApp(
        title: "ece",
        home: StoryPage(
          contents: const [
            Text("AAAAA"),
            MyHomePage(title: 'a'),
            MyHomePage(title: 'b'),
            Text("BBBBB"),
            Text("CCCCC"),
            Text("DDDDD"),
            MyHomePage(title: 'c'),
            MyHomePage(title: 'd'),
          ],
        )
        // Scaffold(
        //   body: Container(
        //       color: Colors.black,
        //       // // child: AnimatedWidgetSlider(contents: [
        //       //   MyHomePage(title: 'initial'),
        //       //   MyHomePage(title: 'Beta'),
        //       //   MyHomePage(title: 'gamma'),
        //       //   MyHomePage(title: 'lambda'),
        //       // ]),
        // child: AnimatedWidgetSlider.builder(
        //   items: [
        //     const MyHomePage(title: 'a'),
        //     const MyHomePage(title: 'b'),
        //     const MyHomePage(title: 'c'),
        //     const MyHomePage(title: 'd'),
        //   ],
        // )),
        // ),
        ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
  final AnimatedWidgetSlider _w = AnimatedWidgetSlider();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _w,
          ElevatedButton(
              onPressed: () =>
                  _w.fromLeft(const MyHomePage(title: 'From fromLeft')),
              child: const Text("Left")),
          ElevatedButton(
              onPressed: () =>
                  _w.fromRight(const MyHomePage(title: 'From fromRight')),
              child: const Text("Right")),
        ],
      ),
    );
  }
}
