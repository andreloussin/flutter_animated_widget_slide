import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_widget_slide/Slide/slide.dart';
// import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class TextSlide extends Slide {
  final String text;
  String? _formatedText;
  List<TextSpan> children = [];

  TextSlide(this.text, {Key? key}) : super(key: key) {
    waitTime = 3000;
    _formatedText = text;
    child = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: formatText(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(10), child: child)));
  }

  List<TextSpan> formatText(final String text) {
    List<TextSpan> spans = [];
    String modifiable = text;
    RegExp re = RegExp(r'@[a-zA-Z0-9_]+');
    RegExp lkre = RegExp(
        r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');
    Iterable<RegExpMatch> tags = re.allMatches(modifiable);
    Iterable<RegExpMatch> links = lkre.allMatches(modifiable);

    int tagCount = 0;
    int linkCount = 0;

    bool proccessing = true;
    while (proccessing) {
      if (tagCount < tags.length && linkCount < links.length) {
        int tagIndex = modifiable.indexOf(tags.elementAt(tagCount).group(0)!);
        String tag = tags.elementAt(tagCount).group(0)!;
        int linkIndex =
            modifiable.indexOf(links.elementAt(linkCount).group(0)!);
        String link = links.elementAt(linkCount).group(0)!;

        if (tagIndex < linkIndex) {
          spans.add(spanFor(text: modifiable.substring(0, tagIndex)));
          spans.add(spanFor(text: tag, type: 2));
          modifiable =
              modifiable.substring(tagIndex + tag.length, modifiable.length);
          tagCount++;
        } else {
          spans.add(spanFor(text: modifiable.substring(0, linkIndex)));
          spans.add(spanFor(text: link, type: 1));
          modifiable =
              modifiable.substring(linkIndex + link.length, modifiable.length);
          linkCount++;
        }
      } else if (tagCount < tags.length) {
        int tagIndex = modifiable.indexOf(tags.elementAt(tagCount).group(0)!);
        String tag = tags.elementAt(tagCount).group(0)!;
        spans.add(spanFor(text: modifiable.substring(0, tagIndex)));
        spans.add(spanFor(text: tag, type: 2));
        modifiable =
            modifiable.substring(tagIndex + tag.length, modifiable.length);
        tagCount++;
      } else if (linkCount < links.length) {
        int linkIndex =
            modifiable.indexOf(links.elementAt(linkCount).group(0)!);
        String link = links.elementAt(linkCount).group(0)!;
        spans.add(spanFor(text: modifiable.substring(0, linkIndex)));
        spans.add(spanFor(text: link, type: 1));
        modifiable =
            modifiable.substring(linkIndex + link.length, modifiable.length);
        linkCount++;
      } else {
        spans.add(spanFor(text: modifiable));
        modifiable = "";
        proccessing = false;
      }
    }
    return spans;
  }

  /// type:
  ///   0 = default
  ///   1 = link
  ///   2 = tag
  TextSpan spanFor({String text = "", int type = 0}) {
    late TextSpan span;
    switch (type) {
      case 0:
        span = TextSpan(text: text);
        break;
      case 1:
        span = TextSpan(
          style: const TextStyle(
            color: Colors.blue,
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print('Tap on link $text');
              // launch(text);
            },
          text: text,
        );
        break;
      case 2:
        span = TextSpan(
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print('Tap on tag $text');
            },
          text: text,
        );
        break;
      default:
        span = const TextSpan();
    }
    return span;
  }
}
