import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/Slide/slide.dart';

// ignore: must_be_immutable
class TextSlide extends Slide {
  final String text;
  String? _formatedText;
  List<TextSpan> children = [];

  TextSlide(this.text, {Key? key}) : super(key: key) {
    waitTime = 3000;
    _formatedText = text;
    child = RichText(text: TextSpan(text: "", children: children));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(10), child: child)));
  }

  RichText formatText(BuildContext context) {
    // Regular expressions
    RegExp re = RegExp(r'@[a-zA-Z0-9_]+');
    RegExp lkre = RegExp(
        r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*[^\.]$)');

    List<String> links = []; // Used for stores the links founds in the text

    // Retreive all links and change them in __?link?__
    Iterable<RegExpMatch> kio = lkre.allMatches(_formatedText!);
    for (RegExpMatch match in kio) {
      String link = match.group(0)!;

      // Delete final dot if exist
      if (RegExp(r'\.$').hasMatch(link)) {
        link = link.substring(0, link.length - 1);
        // Replacelink in _formatedText
        _formatedText = _formatedText!.replaceFirst(link, "__?link?__.");
      } else {
        // Replacelink in _formatedText
        _formatedText = _formatedText!.replaceFirst(link, "__?link?__");
      }
      // Add link to links array
      links.add(link);
    }

    List<String> parts = _formatedText!.split(RegExp(r'[. ,;]'));
    int i = 0;
    for (String part in parts) {
      if (re.hasMatch(part)) {
        children.add(TextSpan(
          text: part,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ));
      } else if (part == "__?link?__") {
        {
          part = links.elementAt(i);
          i++;
        }
        children.add(TextSpan(
          text: part,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ));
      } else {
        children.add(TextSpan(
          text: part,
          // style: DefaultTextStyle.of(context).style,
        ));
      }
    }

    return RichText(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(text: text));
  }
}
