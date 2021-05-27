import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class Lab01 extends StatefulWidget {
  @override
  Lab01State createState() {
    return Lab01State();
  }
}

class Lab01State extends State<Lab01> {
  //
  final _formKey = GlobalKey<FormState>();

  double _value = 0.0;
  DateTime _selectedDate;
  DateTime selectedDate = DateTime.now();
  //

  final checkedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Center(
                    child: Text('Введите данные для регистрации:',
                        style: TextStyle(fontSize: 20)),
                  )),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Введите логин",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введите логин!';
                  }
                  return null;
                },
              ),

              Row(textDirection: TextDirection.ltr, children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Введите пароль",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите пароль!';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ]),
              Container(
                height: 12,
              ),
              // RaisedButton(
              //   child: Text("open picker dialog"),
              //   onPressed: () async {
              //     var datePicked = await DatePicker.showSimpleDatePicker(
              //       context,
              //       // initialDate: DateTime(1994),
              //       firstDate: DateTime(1960),
              //       // lastDate: DateTime(2012),
              //       dateFormat: "dd-MMMM-yyyy",
              //       locale: DateTimePickerLocale.en_us,
              //       looping: true,
              //     );

              //     final snackBar =
              //         SnackBar(content: Text("Date Picked $datePicked"));
              //     Scaffold.of(context).showSnackBar(snackBar);
              //   },
              // ),

              // Scaffold(
              //   body: Center(
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: <Widget>[
              //         Text(
              //           "${selectedDate.toLocal()}".split(' ')[0],
              //           style: TextStyle(
              //               fontSize: 55, fontWeight: FontWeight.bold),
              //         ),
              //         SizedBox(
              //           height: 20.0,
              //         ),
              //         RaisedButton(
              //           onPressed: () => _selectDate(context),
              //           child: Text(
              //             'Select date',
              //             style: TextStyle(
              //                 color: Colors.black, fontWeight: FontWeight.bold),
              //           ),
              //           color: Colors.greenAccent,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Center(
                    child:
                        Text('Дата рождения:', style: TextStyle(fontSize: 20)),
                  )),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DatePickerWidget(
                  looping: true, // default is not looping
                  firstDate: DateTime(1960, 1, 1),
                  // initialDate: DateTime.now()
                  dateFormat: "dd-MMMM-yyyy",
                  //     locale: DatePicker.localeFromString('he'),
                  onChange: (DateTime newDate, _) {
                    _selectedDate = newDate;
                    print(_selectedDate);
                    setState(() {
                      selectedDate = _selectedDate;
                    });
                  },
                  pickerTheme: DateTimePickerTheme(
                    itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                    dividerColor: Colors.grey,
                  ),
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.only(bottom: 30),
              //   child: ElevatedButton(
              //     onPressed: () {
              //     },
              //     child: Text('Отправить'),
              //   ),
              //  ),

              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Center(
                    child: Text('Сколько вам полных лет:',
                        style: TextStyle(fontSize: 20)),
                  )),
              SfSlider(
                min: 0.0,
                max: 70.0,
                value: _value,
                stepSize: 1,
                interval: 10,
                // showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                onChanged: (dynamic value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Center(
                    child: Text('Дата рождения:',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25)),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: <Widget>[
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Уведомление',
                              textAlign: TextAlign.center,
                            ),
                            content: const Text(
                                'Спасибо за регистрацию на нашем ресурсе',
                                textAlign: TextAlign.center),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Назад'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Регистрация'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
