import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:lab/main.dart';


class Lab08 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Lab08State();
}

class _Lab08State extends State<Lab08> {
  final authLink = 'https://51.15.91.29/laskin/jwt/auth';
  final protectedLink = 'https://51.15.91.29/laskin/jwt/protected';
  final HttpClient client = new HttpClient();

  String token = '';
  String responseText = '';
  Uint8List responseImage;

  _Lab08State() {
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  }

  Widget _ImageWrapper() {
    if (responseImage == null) {
      return LinearProgressIndicator();
    }

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        image: new DecorationImage(
            fit: BoxFit.cover, image: MemoryImage(responseImage, scale: 1)),
      ),
    );
  }

  void getToken() {
    // MyApp.analytics.logEvent(
    //     name: 'ButtonClick', parameters: {'ButtonName': 'GetTokenButton'});
    client.getUrl(Uri.parse(authLink)).then((HttpClientRequest request) {
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.
      print(request);
      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      response.listen((event) {
        String responseString = String.fromCharCodes(event);
        setState(() {
          token = json.decode(responseString)['token'];
          print(token);
        });
      });
    });
  }

  void getProtected() {
    // MyApp.analytics.logEvent(
    //     name: 'ButtonClick',
    //     parameters: {'ButtonName': 'GetProtectedWithJWTButton'});
    client
        .getUrl(Uri.parse('$protectedLink?token=$token'))
        .then((HttpClientRequest request) {
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.

      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      if (response.statusCode != 200) {
        response.listen((event) {
          String responseString = String.fromCharCodes(event);
          setState(() {
            responseText = responseString;
          });
        });
      } else {
        String gotResponse = '';
        response.forEach((element) {
          gotResponse += String.fromCharCodes(element);
        }).then((value) {
          var jsonDecoded = json.decode(gotResponse);
          String message = jsonDecoded['message'];
          String time = DateTime.fromMicrosecondsSinceEpoch(
                  jsonDecoded['timestamp'].toInt() * 1000000)
              .toString();
          setState(() {
            responseText = '"message": "$message"\n"time":"$time"\n"photo":';
            try {
              responseImage = base64.decode(jsonDecoded['image']);
            } catch (e) {
              print(e);
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            child: Text('token: $token', textAlign: TextAlign.center)),
        ElevatedButton(onPressed: getToken, child: Text(authLink)),
        ElevatedButton(onPressed: getProtected, child: Text(protectedLink)),
        Text('Response'),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                Text(
                  responseText,
                  textAlign: TextAlign.center,
                ),
                _ImageWrapper(),
              ],
            )),
      ],
    ));
  }
}
