// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  late StreamVideoPlayer screen;
  VideoPlayerApp({super.key}) {
    screen = StreamVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: screen,
    );
  }
}

class StreamVideoPlayer extends StatefulWidget {
  _StreamVideoPlayerState? vpss;
  late final String? link;
  late final Function(int duration)? onInitialized;
  StreamVideoPlayer(
      {Key? key, this.link, Function(int waitTime)? onInitialized})
      : super(key: key) {
    this.onInitialized = onInitialized ??
        (waitTime) {
          print("onInitialized is free");
        };
  }

  @override
  _StreamVideoPlayerState createState() {
    vpss = _StreamVideoPlayerState();
    return vpss!;
  }
}

class _StreamVideoPlayerState extends State<StreamVideoPlayer> {
  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
      widget.link ??
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    try {
      _initializeVideoPlayerFuture = controller.initialize();
      controller.play();
      controller.setLooping(true);
      controller.addListener(() {
        setState(() {});
      });
    } catch (e) {
      print("$e");
    }
    // listenVideoIsLoading();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //widget.onInitialized!(controller.value.duration.inMilliseconds);

          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              Visibility(
                  visible: controller.value.isBuffering,
                  child: const CircularProgressIndicator())
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
