import 'package:flutter/material.dart';
import 'package:cube_transition_plus/cube_transition_plus.dart';

class Diaporama extends StatelessWidget {
  final List<Widget>? contents;

  const Diaporama({super.key, this.contents});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.8;
    return Center(
      child: SizedBox(
        height: height,
        child: CubePageView(
          children: contents,
        ),
      ),
    );
  }
}
