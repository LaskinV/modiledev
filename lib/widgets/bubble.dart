import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class BubbleWidget extends StatelessWidget {
  final String text;
  final String timeString;
  final bool isResponse;
  final bool isReceived;
  final int timestamp;

  String get getText => this.text;
  String get getTimeString => this.timeString;
  bool get getIsResponse => this.isResponse;
  int get getTimestamp => this.timestamp;

  BubbleWidget({
    this.text,
    this.timeString,
    this.timestamp,
    this.isResponse = false,
    this.isReceived = false,
  });

  Row makeRowTextAndTime() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(
        timeString,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 12,
        ),
      ),
    ]);
  }

  Row makeRowTextAndTimeWithIconDone() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(
        timeString,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 12,
        ),
      ),
      SizedBox(
        width: 2,
      ),
      Icon(
        Icons.done,
        color: Colors.green,
        size: 12,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) => Bubble(
      margin: BubbleEdges.symmetric(vertical: 10),
      alignment: (isResponse) ? Alignment.topLeft : Alignment.topRight,
      nipWidth: 8,
      nipHeight: 24,
      nip: (isResponse) ? BubbleNip.leftTop : BubbleNip.rightTop,
      color: (isResponse)
          ? Color.fromRGBO(241, 214, 226, 1)
          : Color.fromRGBO(225, 255, 199, 1.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text),
            (isReceived)
                ? makeRowTextAndTimeWithIconDone()
                : makeRowTextAndTime(),
          ]));
}
