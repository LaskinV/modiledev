import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:lab/widgets/bubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class Lab07 extends StatefulWidget {
  @override
  _Lab07State createState() {
    return _Lab07State();
  }
}

class _Lab07State extends State<Lab07> {
  TextEditingController _textFieldController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  IO.Socket socket;
  List<BubbleWidget> bubbleWidgetsList = <BubbleWidget>[];
  String statusMsg = 'Offline';
  _Lab07State() {
    socket = IO.io('ws://51.15.91.29:8124',
        IO.OptionBuilder().setTransports(['websocket']).build());
    connectAndListen();
  }

  void connectAndListen() {
    socket.onConnect((_) {
      setState(() {
        statusMsg = 'Connected';
      });
    });

    // socket.on('received', (data) {
    //   var received = json.decode(data);
    //   print(received);
    //   setState(() {
    //     for (int i = 0; i < bubbleWidgetsList.length; i++) {
    //       if (bubbleWidgetsList[i].getTimestamp == received['time']) {
    //         bubbleWidgetsList[i] = BubbleWidget(
    //           text: received['text'].toString(),
    //           timeString: getTimeStringFromTimestamp(received['time']),
    //           isResponse: false,
    //           isReceived: true,
    //           timestamp: received['time'],
    //         );
    //       }
    //     }
    //   });
    // });

    socket.on('response', (data) {
      print('response: ' + data);
      var received = json.decode(data);
      bubbleWidgetsList.add(BubbleWidget(
        text: received['text'].toString(),
        timeString: getTimeStringFromTimestamp(received['time'] * 1000),
        isResponse: true,
        timestamp: received['time'] * 1000,
      ));
    });

    socket.onDisconnect((_) {
      setState(() {
        statusMsg = 'Reconnecting...';
      });
    });
  }

  String getCurrentTime() {
    DateTime currentDateTime = DateTime.now();
    int hour = currentDateTime.hour;
    int minute = currentDateTime.minute;
    String hourString = hour.toString();
    String minuteString = minute.toString();
    if (hour < 10) {
      hourString = '0${hour.toString()}';
    }
    if (minute < 10) {
      minuteString = '0${minute.toString()}';
    }
    return '$hourString:$minuteString';
  }

  String getTimeStringFromTimestamp(int timestamp) {
    DateTime currentDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int hour = currentDateTime.hour;
    int minute = currentDateTime.minute;
    String hourString = hour.toString();
    String minuteString = minute.toString();
    if (hour < 10) {
      hourString = '0${hour.toString()}';
    }
    if (minute < 10) {
      minuteString = '0${minute.toString()}';
    }
    return '$hourString:$minuteString';
  }

  // int _index;
  // String _botReply = '';
  // final GlobalKey<AnimatedListState> _listkey = GlobalKey();
  // List<String> _data = [];
  TextEditingController queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ListView(
            children: bubbleWidgetsList,
            controller: _scrollController,
            // key: _listkey,
            // initialItemCount: _data.length,
            // itemBuilder:
            //     (BuildContext context, int index, Animation animation) {
            //   return buildItem(_data[index], animation, index);
            // },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ColorFiltered(
              colorFilter: ColorFilter.linearToSrgbGamma(),
              child: Container(
                  color: Colors.grey,
                  child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.message),
                            hintText: "Текст сообщения"),
                        controller: queryController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (msg) {
                          this.getResponse();
                        },
                      ))),
            ),
          ),
          // StreamBuilder(
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       _botReply = snapshot.data;
          //       print(_botReply);
          //       print(snapshot.data);
          //     }
          //     return Text('');
          //   },
          // )
        ],
      ),
    );
  }

  void getResponse() async {
    if (queryController.text.length > 0) {
      this.insertSingleItem(queryController.text.toString());
      try {
        queryController.text = '';
      } finally {}
      await Future<void>.delayed(Duration(seconds: 1));
    }
  }

  void insertSingleItem(String message) {
    if (message.length > 0) {
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var data = {'text': message, 'time': timestamp};

      socket.emit('message', json.encode(data));
      setState(() {
        _textFieldController.text = '';
        bubbleWidgetsList.add(BubbleWidget(
            text: message,
            timeString: getCurrentTime(),
            isResponse: false,
            timestamp: timestamp));
      });
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}

// Widget buildItem(String item, Animation animation, int index) {
//   bool mine = item.endsWith("<bot>");
//   return SizeTransition(
//     sizeFactor: animation,
//     child: Padding(
//       padding: EdgeInsets.only(top: 10),
//       child: Container(
//         alignment: mine ? Alignment.topLeft : Alignment.topRight,
//         child: Bubble(
//           child: Text(
//             item.replaceAll("<bot>", ""),
//             style: TextStyle(
//                 fontSize: 18.0, color: mine ? Colors.white : Colors.black),
//           ),
//           color: mine ? Colors.blue : Colors.grey[200],
//           padding: BubbleEdges.all(15),
//           nip: mine ? BubbleNip.leftTop : BubbleNip.rightTop,
//         ),
//         padding: EdgeInsets.all(12),
//       ),
//     ),
//   );
// }
