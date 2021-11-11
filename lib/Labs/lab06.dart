import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as Enc;
// import 'drawer.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Lab6 extends StatefulWidget {
  Lab6({Key key}) : super(key: key);
  @override
  _Lab6State createState() => _Lab6State();
}

class _Lab6State extends State<Lab6> {
  final keyField = TextEditingController();
  final textField = TextEditingController();

  @override
  void dispose() {
    keyField.dispose();
    textField.dispose();
    super.dispose();
  }

  String _enc;
  String _dec;
  String decrypted;

  Future<void> encrypt(String keyStr) async {
    final plainText = textField.text;
    final len = keyStr.length;
    if (keyStr.length < 32) {
      for (int i = 0; i < 32 - len; i++) {
        keyStr = "$keyStr ";
      }
    }
    print("Ключ: $keyStr");
    final key = Enc.Key.fromUtf8(keyStr);
    final iv = Enc.IV.fromLength(16);

    final encrypter = Enc.Encrypter(Enc.AES(key, padding: null));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    _enc = encrypted.base64;

    print("Зашифрованное: $_enc"); //print(_enc);

    await _write(_enc);
    //return _enc;
  }

  Future<void> decrypt(String keyStr) async {
    final plainText = await _read();
    final len = keyStr.length;
    if (keyStr.length < 32) {
      for (int i = 0; i < 32 - len; i++) {
        keyStr = "$keyStr ";
      }
    }

    print("Ключ: $keyStr");
    final key = Enc.Key.fromUtf8(keyStr);
    final iv = Enc.IV.fromLength(16);

    final encrypter = Enc.Encrypter(Enc.AES(key, padding: null));
    final encryptedText = Enc.Encrypted.fromBase64(plainText);

    final decrypted = encrypter.decrypt(encryptedText, iv: iv);

    print("Расшифрованное: $decrypted");
    //print(decrypted);
    _dec = decrypted;
    //return decrypted;
  }

  Future<void> _write(String text) async {
    Directory directory = await getExternalStorageDirectory();
    print(directory.path);
    File file = File('${directory.path}/my_file.txt');
    {
      Clipboard.setData(new ClipboardData(text: '$_enc)'));
    }
    //print(file);
    await file.writeAsString(text);
  }

  Future<String> _read() async {
    String text;
    try {
      Directory directory = await getExternalStorageDirectory();
      File file = File('${directory.path}/my_file.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    // print('');
    // print(text);
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 12),
                    child: Container(
                      height: 60,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.blueAccent,
                        ),
                        child: TextField(
                            controller: keyField,
                            maxLength: 32,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.vpn_key),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              labelText: 'Введите ключ',
                            )),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //ElevatedButton(onPressed: () {}, child: Text('data')),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          onPressed: () async {
                            await encrypt(keyField.text);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(_enc)));
                          },
                          child: Text(
                            'Зашифровать',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[100]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextButton(
                          onPressed: () async {
                            await decrypt(keyField.text);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(_dec)));
                          },
                          child: Text(
                            'Расшифровать',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[100]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.blueAccent,
                      ),
                      child: TextField(
                          controller: textField,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.text_fields),
                            labelText: 'Введите текст',
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
