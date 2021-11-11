import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera_camera/camera_camera.dart';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:lab/main.dart';

// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key key}) : super(key: key);

//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }

// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   // SingingCharacter? _character = SingingCharacter.Video;

//   int id = 1;
//   String radioButtonItem;
//   var frame = Container();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Radio(
//               value: 1,
//               groupValue: id,
//               onChanged: (val) {
//                 setState(() {
//                   radioButtonItem = 'Video';
//                   id = 1;
//                   VideoPlayer();
//                 });
//               },
//             ),
//             Text(
//               'Video',
//               style: new TextStyle(fontSize: 17.0),
//             ),
//             Radio(
//               value: 2,
//               groupValue: id,
//               onChanged: (val) {
//                 setState(() {
//                   radioButtonItem = 'Camera';
//                   id = 2;
//                   CameraScreen();
//                 });
//               },
//             ),
//             Text(
//               'Camera',
//               style: new TextStyle(
//                 fontSize: 17.0,
//               ),
//             ),
//           ],
//         ),
//         frame,
//       ]),
//     );
//   }
// }

class Lab02 extends StatefulWidget {
  @override
  Lab02State createState() {
    return Lab02State();
  }
}

class Lab02State extends State<Lab02> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    // MyStatefulWidget(),
    // VideoPlayer(),
    CameraScreen(),
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
            icon: Icon(Icons.movie),
            label: 'Видео',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_outlined),
            label: 'Камера',
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

// class VideoPlayer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: VideoItems(
//         // videoPlayerController: VideoPlayerController.network(
//         //   'http://techslides.com/demos/samples/sample.mp4',
//         // ),
//         looping: true,
//         autoplay: true,
//         autoInitialize: false,
//         allowFullScreen: false,
//       ),
//     );
//   }
// }

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;
  final autoInitialize;
  final allowFullScreen;

  VideoItems({
    @required this.videoPlayerController,
    this.looping,
    this.autoplay,
    this.autoInitialize,
    this.allowFullScreen,
    Key key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 4 / 3,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File val;

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
                    child: Icon(Icons.camera_alt),
                    onPressed: () async {
                      val = await showDialog(
                          context: context,
                          builder: (context) => Camera(
                                orientationEnablePhoto: CameraOrientation.all,
                                mode: CameraMode.fullscreen,
                              ));
                      setState(() {});
                      final params =
                          SaveFileDialogParams(sourceFilePath: val.path);
                      final filePath =
                          await FlutterFileDialog.saveFile(params: params);
                      print(filePath);
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
                    ? Image.file(
                        val,
                        fit: BoxFit.contain,
                      )
                    : Center(
                        child: Text("Чтобы сделать фото нажмите на кнопку",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25))))));
  }
}
