import 'package:flutter/material.dart';
import 'Labs/lab01.dart';
import 'Labs/lab02.dart';
import 'Labs/lab03.dart';
import 'Labs/lab04.dart';
import 'Labs/lab05.dart';
import 'Labs/lab06.dart';
import 'Labs/lab07.dart';
import 'Labs/lab08.dart';
import 'Labs/lab09.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторные работы',
      theme: ThemeData(primarySwatch: Colors.grey),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Лабораторные работы')),
      backgroundColor: Colors.white,
      body: SwipeTabBar(),
    );
  }
}

// class MyStatelessWidget extends StatelessWidget {
//   const MyStatelessWidget({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     PageController controller = PageController(initialPage: 0);
//     return PageView(
//       controller: controller,
//       children: [
//         for (var i = 1; i < 10; i++)
//           Text('Lab $i', style: TextStyle(fontSize: 25.0))
//       ],
//       scrollDirection: Axis.horizontal,
//     );
//   }
// }

class SwipeTabBar extends StatefulWidget {
  @override
  _SwipeTabBarState createState() => _SwipeTabBarState();
}

class _SwipeTabBarState extends State<SwipeTabBar> {
  final _pageViewController = PageController();

  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        children: <Widget>[
          Lab01(),
          Lab02(),
          Lab03(),
          Lab04(),
          Lab05(),
          Lab06(),
          Lab07(),
          Lab08(),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Здесь что-то будет',
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
        onPageChanged: (index) {
          setState(() {
            _activePage = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activePage,
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 1),
        backgroundColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          for (var i = 1; i < 10; i++)
            BottomNavigationBarItem(
                icon: Text("Lab $i"),
                activeIcon: Text("Lab $i",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                title: Text(" "))
        ],
      ),
    );
  }
}

