import 'package:flutter/material.dart';
import 'package:lab/widgets/friendCard.dart';
import 'package:lab/widgets/friendCardSmall.dart';
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FriendsList extends StatefulWidget {
  final accessToken;
  final userId;

  FriendsList({this.accessToken, this.userId});

  @override
  State<StatefulWidget> createState() =>
      new FriendsListState(accessToken: accessToken, userId: userId);
}

class FriendsListState extends State<FriendsList> {
  final accessToken;
  final userId;
  var friendsMap;
  var friendsAmout = 0;
  int gridAxisCount = 2;
  double gridAspectRatio = 1;
  List<Icon> navBarIcons = [Icon(Icons.grid_on), Icon(Icons.grid_off)];
  int navBarIconIndex = 1;
  bool isFriendsListLoaded = false;
  Color refreshButtonColor = Colors.deepOrange;

  List<List<Widget>> friendsWidgetsList = [
    <Widget>[],
    <Widget>[],
  ];
  int currentFriendsListWidgetsIndex = 0;

  FriendsListState({this.accessToken, this.userId}) {
    getFriendsListWidgets();
  }

  processBuild() async {
    await getFriendsListWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Друзья: $friendsAmout'),
        actions: [
          IconButton(
              icon: navBarIcons[navBarIconIndex],
              onPressed: () {
                setState(() {
                  gridAxisCount = (gridAxisCount) % 2 + 1;
                  navBarIconIndex = (navBarIconIndex + 1) % 2;
                  currentFriendsListWidgetsIndex =
                      (currentFriendsListWidgetsIndex + 1) % 2;
                  if (gridAspectRatio == 1)
                    gridAspectRatio = 3;
                  else if (gridAspectRatio == 3) gridAspectRatio = 1;
                });
              }),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: gridAspectRatio,
        crossAxisCount: gridAxisCount,
        children: friendsWidgetsList[currentFriendsListWidgetsIndex],
      ),
    );
  }

  getFriendsList() async {
    try {
      var response = await http.get(
          'https://api.vk.com/method/friends.get?user_id=$userId&access_token=$accessToken&v=5.130&fields=nickname,photo_200,online,domain,city,country');
      if (response.statusCode == 200) {
        var friendsList = jsonDecode(response.body)['response'];
        setState(() {
          friendsAmout = friendsList['count'];
        });
        return friendsList['items'];
      }
    } catch (error) {
      return <dynamic>[];
    }
  }

  getFriendsListWidgets() async {
    var stream = streamOfFriendsMaps(friendsMap);
    await for (Map<String, dynamic> friendMap in stream) {
      try {
        FriendCard card = FriendCard(
          name: friendMap['name'],
          img: friendMap['img'],
          id: friendMap['id'],
          online: friendMap['online'],
        );
        FriendCardSmall cardSmall = FriendCardSmall(
          name: friendMap['name'],
          img: friendMap['img'],
          id: friendMap['id'],
          online: friendMap['online'],
          city: friendMap['city'],
        );
        setState(() {
          friendsWidgetsList[0] = [...friendsWidgetsList[0], card];
          friendsWidgetsList[1] = [...friendsWidgetsList[1], cardSmall];
        });
      } catch (error) {}
    }
    refreshButtonColor = Colors.blueAccent;
    isFriendsListLoaded = true;
  }

  Stream<Map<String, dynamic>> streamOfFriendsMaps(
      List<dynamic> friendsMap) async* {
    friendsMap = await getFriendsList();
    try {
      for (var i = 0; i < friendsMap.length; ++i) {
        String name = friendsMap[i]['first_name'].toString() +
            ' ' +
            friendsMap[i]['last_name'].toString();
        String id = friendsMap[i]['domain'].toString();
        String urlPhoto = friendsMap[i]['photo_200'].toString();
        String online = friendsMap[i]['online'].toString();
        String city = friendsMap[i]['city'].toString();
        String country = friendsMap[i]['country'].toString();
        if (city != 'null') {
          city = friendsMap[i]['city']['title'].toString();
        } else
          city = '';
        if (country != 'null') {
          country = friendsMap[i]['country']['title'].toString();
        } else
          country = '';
        String region = country;
        if (city.length > 0 && country.length > 0)
          region += ', ' + city;
        else if (city.length > 0 && country.length == 0) region += city;
        await Future.delayed(Duration(milliseconds: 100));

        yield {
          'name': name,
          'img': urlPhoto,
          'id': id,
          'online': online,
          'city': region,
        };
      }
    } catch (error) {
      print(error);
    }
  }
}



// import 'package:flutter/material.dart';

// class Lab05 extends StatefulWidget {
//   const Lab05({Key key}) : super(key: key);

//   @override
//   _Lab05State createState() => _Lab05State();
// }

// class _Lab05State extends State<Lab05> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Text("Работа находится в разработке",
//             textAlign: TextAlign.center, style: TextStyle(fontSize: 25)));
//   }
// }
