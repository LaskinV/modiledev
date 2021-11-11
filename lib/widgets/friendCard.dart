import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FriendCard extends StatefulWidget {
  final img;
  final name;
  final id;
  final String online;

  FriendCard({this.name, this.img, this.id, this.online});

  @override
  State<StatefulWidget> createState() =>
      FriendCardState(name: name, img: img, id: id, online: online);
}

class FriendCardState extends State<FriendCard> {
  final String img;
  final String name;
  final String id;
  final String online;

  FriendCardState({this.name, this.img, this.id, this.online});

  @override
  Widget build(BuildContext context) => FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: Container(
          child: Image.network(
            img,
            fit: BoxFit.cover,
          ),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 4)]),
        ),
        back: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.indigo[100],
              border: Border.all(width: 1.0, color: Colors.cyan[400]),
              boxShadow: [BoxShadow(color: Colors.cyan[400], blurRadius: 4)]),
          child: Column(
            children: [
              Text(
                (online == '1') ? 'online' : 'offline',
                style: TextStyle(
                    color:
                        (online == '1') ? Colors.green[500] : Colors.red[800]),
              ),
              Expanded(
                  child: Center(
                      child: Text(
                name,
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              ))),
              Text(
                id,
              ),
            ],
          ),
        ),
      );
}
