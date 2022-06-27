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
  Function(bool data)? listener;
  VideoPlayerScreen(
      {super.key,
      this.link,
      this.controller,
      Function(int waitTime)? onInitialized,
      Function(bool data)? listener}) {
    this.listener = listener ?? (data) {};
    this.onInitialized = onInitialized ?? (waitTime) {};
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
    // assureNotAutoScroll();
  }

  @override
  void initState() {
    super.initState();
    widget.controller = VideoPlayerController.network(
      widget.link != null
          ? widget.link!
          : 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    try {
      _initializeVideoPlayerFuture = widget.controller!.initialize();
      widget.controller!.addListener(() {
        setState(() {
          widget.listener!(widget.controller!.value.isBuffering);
        });
      });
      widget.controller?.play();
    } catch (e) {}
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!lengthSent) {
            widget.onInitialized!(
                widget.controller!.value.duration.inMilliseconds);
            lengthSent = true;
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: widget.controller!.value.aspectRatio,
                child: VideoPlayer(widget.controller!),
              ),
              Visibility(
                  visible: widget.controller!.value.isBuffering,
                  child: const CircularProgressIndicator())
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
