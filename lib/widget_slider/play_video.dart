import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/widget_slider/animated_widget_slider.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  late VideoPlayerScreen screen;
  VideoPlayerApp({super.key}) {
    screen = VideoPlayerScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: screen,
    );
  }

  void setMethod(AnimatedWidgetSliderController? parentController) {
    screen.setMethod(parentController);
  }
}

class VideoPlayerScreen extends StatefulWidget {
  _VideoPlayerScreenState? vpss;
  VideoPlayerScreen({super.key}) {
    // vpss = _VideoPlayerScreenState();
  }

  @override
  _VideoPlayerScreenState createState() {
    vpss = _VideoPlayerScreenState();
    return vpss!;
  }

  void setMethod(AnimatedWidgetSliderController? parentController) {
    vpss?.setMethod(parentController);
  }
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  AnimatedWidgetSliderController? parentController;

  void setMethod(AnimatedWidgetSliderController? parentController) {
    this.parentController = parentController;
    assureNotAutoScroll();
  }

  Future<void> assureNotAutoScroll() async {
    while (_controller.value.isPlaying) {
      parentController?.pause();
      await Future.delayed(Duration(milliseconds: 300));
      print("object ${_controller.value.isPlaying}");
    }
    print("assure not auto scroll");
    parentController?.play();
  }

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butterfly Video'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
              while (!_controller.value.isPlaying) {}
            } else {
              // If the video is paused, play it.
              _controller.play();
              while (_controller.value.isPlaying) {}
            }
            print("${_controller.value.isPlaying}");
            assureNotAutoScroll();
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
