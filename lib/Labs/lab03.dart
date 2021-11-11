import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class Lab03 extends StatefulWidget {
  @override
  Lab03State createState() {
    return Lab03State();
  }
}

class Lab03State extends State<Lab03> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    HTMLDownload(),
    CelciumDownload(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.web_asset_outlined),
            label: 'HTML',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_cloudy_outlined),
            label: 'Погода',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HTMLDownload extends StatefulWidget {
  @override
  _HTMLDownloadState createState() => _HTMLDownloadState();
}

class _HTMLDownloadState extends State<HTMLDownload> {
  var val;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 31),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    child: Icon(Icons.arrow_downward),
                    onPressed: () async {
                      val = await http
                          .get(Uri.https('yandex.ru', 'pogoda/moscow'));
                      val = val.body;
                      setState(() {});
                    }),
              ),
            ),
          ],
        ),
        body: Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.9,
                child: val != null
                    ? ListView(children: <Widget>[Html(data: val)])
                    : Center(
                        child: Text("Нажмите кнопку чтобы вывести HTTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25))))));
  }
}

class CelciumDownload extends StatefulWidget {
  @override
  _CelciumDownloadState createState() => _CelciumDownloadState();
}

class _CelciumDownloadState extends State<CelciumDownload> {
  var val2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 31),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    child: Icon(Icons.arrow_downward),
                    onPressed: () async {
                      val2 = await http
                          .get(Uri.https('yandex.ru', 'pogoda/moscow'));
                      dom.Document document = parser.parse(val2.body);
                      var content = document
                          .getElementsByClassName('fact__temp')[0]
                          .getElementsByClassName('temp__value_with-unit')[0]
                          .innerHtml;
                      val2 = content.toString();
                      setState(() {});
                    }),
              ),
            ),
          ],
        ),
        body: Center(
            child: Container(
                child: val2 != null
                    ? Center(
                        child: Text('В Москве: ' + val2 + '°C',
                            style: TextStyle(fontSize: 50)))
                    : Center(
                        child: Text(
                            "Нажмите кнопку чтобы посмотреть температуру !",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25))))));
  }
}
