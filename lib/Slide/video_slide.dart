import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/Slide/slide.dart';
import 'package:flutter_animated_widget_slide/widget_slider/play_video.dart';
import 'package:video_player/video_player.dart';

class VideoSlide extends Slide {
  final String? link;

  VideoSlide({this.link}) {
    needPause = true;
    waitTime = 10000;
    child = VideoPlayerScreen(
      link: link,
      onInitialized: (waitTime) {
        print("new wait time === $waitTime");
        needPause = false;
        this.waitTime = waitTime;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Center(child: child));
  }

  @override
  void pause() {
    (child as VideoPlayerScreen).controller?.pause();
  }

  @override
  void play() {
    (child as VideoPlayerScreen).controller?.play();
  }
}
