import 'package:flutter/material.dart';

class FriendCardSmall extends StatefulWidget {
  final img;
  final name;
  final id;
  final String online;
  final String city;

  FriendCardSmall({this.name, this.img, this.id, this.online, this.city});

  @override
  State<StatefulWidget> createState() => FriendCardSmallState(
      name: name, img: img, id: id, online: online, city: city);
}

class FriendCardSmallState extends State<FriendCardSmall> {
  final String img;
  final String name;
  final String id;
  final String online;
  final String city;

  FriendCardSmallState({this.name, this.img, this.id, this.online, this.city});

  @override
  Widget build(BuildContext context) => Card(
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.cyan, width: 0.5)),
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                img,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                    ),
                    Text(city),
                    Text(id),
                  ],
                ),
              ),
              Container(
                alignment: AlignmentDirectional.topEnd,
                child: Icon(Icons.circle,
                    color:
                        (online == '1') ? Colors.green[500] : Colors.red[800],
                    size: 14),
              )
            ],
          ),
        ),
      );
}
