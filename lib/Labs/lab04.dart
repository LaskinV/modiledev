import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'lab05.dart';

class Lab04 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Lab04State();
}

class Lab04State extends State<Lab04> {
  final loginVkView = LoginVK();

  @override
  Widget build(BuildContext context) {
    ;
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(
              child: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => loginVkView));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Авторизация через ВК',
                        textScaleFactor: 1,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )),
          )),
        ],
      ),
    );
  }
}

class LoginVK extends StatefulWidget {
  @override
  _LoginVKState createState() => new _LoginVKState();
}

class _LoginVKState extends State<LoginVK> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String accessToken = '';
  String userId = '';
  String userImageUrl = '';
  String userFirstname = '';
  String userLastname = '';

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        getAccessToken(url);
        getUserId(url);
      }
    });
  }

  getAccessToken(String url) {
    setState(() {
      print("URL changed: $url");
      if (url.contains('access_token=')) {
        RegExp regExpToken = new RegExp("#access_token=([A-z0-9]*)");
        this.accessToken = regExpToken.firstMatch(url)?.group(1);
        print("token $accessToken");
      }
    });
  }

  getUserId(String url) {
    setState(() {
      print("URL changed: $url");
      if (url.contains('user_id=')) {
        RegExp regExpUserId = new RegExp("user_id=([0-9]*)");
        this.userId = regExpUserId.firstMatch(url)?.group(1);
        print('USER_ID = $userId');
        setUserData();
        flutterWebviewPlugin.dispose();
      }
    });
  }

  setUserData() async {
    var url =
        'https://api.vk.com/method/users.get?user_id=$userId&access_token=$accessToken&fields=photo_50&v=5.130';
    try {
      final response = await http.get(url);
      var jsonData = jsonDecode(response.body);
      jsonData = jsonData['response'][0];
      setState(() {
        userFirstname = jsonData['first_name'];
        userLastname = jsonData['last_name'];
        userImageUrl = jsonData['photo_50'];
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    String loginUrl =
        "https://oauth.vk.com/authorize?client_id=7824991&response_type=token&display=page&redirect_uri=https://oauth.vk.com/blank.html";

    return new WebviewScaffold(
      url: loginUrl,
      appBar: new AppBar(
          title: new Text("Login by Vk: $userFirstname $userLastname"),
          leading: Image.network(
              userImageUrl ?? 'https://picsum.photos/250?image=9')),
      withZoom: true,
      withLocalStorage: true,
      withJavascript: true,
      bottomNavigationBar: Padding(
        child: Text('Токен: ' + accessToken),
        padding: EdgeInsets.all(12),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          child: Text('Друзья'),
          onPressed: () {
            if (!(accessToken.isEmpty && userId.isEmpty)) {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendsList(
                          accessToken: accessToken, userId: userId)));
            }
          },
        ),
        ElevatedButton(
          child: Text('Сбросить Cookies'),
          onPressed: () {
            flutterWebviewPlugin.cleanCookies();
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text('Назад'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';

// class Lab04 extends StatefulWidget {
//   const Lab04({Key key}) : super(key: key);

//   @override
//   _Lab04State createState() => _Lab04State();
// }

// class _Lab04State extends State<Lab04> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Text("Работа находится в разработке",
//             textAlign: TextAlign.center, style: TextStyle(fontSize: 25)));
//   }
// }
