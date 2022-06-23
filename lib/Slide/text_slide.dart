import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/Slide/slide.dart';

class TextSlide extends Slide {
  final String text;
  String? _formatedText;

  TextSlide(this.text) {
    waitTime = 3000;
    _formatedText = text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(10), child: child)));
  }

  RichText formatText() {
    RegExp re = RegExp(r'@[a-zA-Z0-9_]+');
    RegExp lkre = RegExp(
        r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');
    List<String> links = [];
    var kio = lkre.allMatches(_formatedText!);
    for (RegExpMatch match in kio) {
      String link = match.group(0)!;
      if (RegExp(r'\.$').hasMatch(link)) {
        link = link.substring(0, link.length - 1);
      }
      links.add(link);
      _formatedText = _formatedText!.replaceAll(link, "__?link?__");
    }
    List<String> parts = _formatedText!.split(RegExp(r'[. ,;]'));
    int i = 0;
    for (String part in parts) {
      if (re.hasMatch(part)) {
        print("__tag:::$part:::tag__");
      } else if (part == "__?link?__") {
        print("part $i == $part");
        part = links.elementAt(i);
        i++;
        print(part);
      } else {
        print(part);
      }
    }

    return RichText(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(text: text));
  }
}
