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
  late VideoPlayerController? controller;
  _VideoPlayerScreenState? vpss;
  late final String? link;
  late final Function(int waitTime)? onInitialized;
  VideoPlayerScreen(
      {super.key,
      this.link,
      this.controller,
      Function(int waitTime)? onInitialized}) {
    this.onInitialized = onInitialized ??
        (waitTime) {
          print("onInitialized was free");
        };
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
  late Future<void> _initializeVideoPlayerFuture;
  AnimatedWidgetSliderController? parentController;
  bool lengthSent = false;

  void setMethod(AnimatedWidgetSliderController? parentController) {
    this.parentController = parentController;
    assureNotAutoScroll();
  }

  Future<void> assureNotAutoScroll() async {
    // while (_controller.value.isPlaying) {
    //   parentController?.pause();
    //   await Future.delayed(Duration(milliseconds: 300));
    //   print("object ${_controller.value.isPlaying}");
    // }
    // print("assure not auto scroll");
    // parentController?.play();
  }

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    widget.controller = VideoPlayerController.network(
      widget.link != null
          ? widget.link!
          : 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    try {
      _initializeVideoPlayerFuture = widget.controller!.initialize();
      widget.controller?.play();
    } catch (e) {}
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          widget
              .onInitialized!(widget.controller!.value.duration.inMilliseconds);
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return AspectRatio(
            aspectRatio: widget.controller!.value.aspectRatio,
            // Use the VideoPlayer widget to display the video.
            child: GestureDetector(
              // When the child is tapped, show a snackbar.
              onTap: () {
                // if (_controller.value.isPlaying) {
                //   _controller.pause();
                //   while (!_controller.value.isPlaying) {}
                // } else {
                //   // If the video is paused, play it.
                //   _controller.play();
                //   while (_controller.value.isPlaying) {}
                // }
                print(
                    "_controller.value.isPlaying: ${widget.controller!.value.isPlaying}");
              },
              child: VideoPlayer(widget.controller!),
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void listenVideoStreaming() async {
    while (widget.controller!.value.isBuffering) {
      if (widget.controller!.value.isInitialized) ;
    }
    while (widget.controller!.value.isInitialized);
  }
}
