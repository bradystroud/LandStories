import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../Database/getW3W.dart';
import '../Database/Database.dart';
import '../Database/Models.dart';
import '../widgets/textField.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text("New Task"),
        ),
        body: NewTaskDetails());
  }
}

class NewTaskDetails extends StatefulWidget {
  @override
  _NewTaskDetailsState createState() => _NewTaskDetailsState();
}

class _NewTaskDetailsState extends State<NewTaskDetails> {
  Future<What3Words> futureWhat3Words;

  Future<Position> _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {});
    return location;
  }

  void initState() {
    super.initState();
    _displayCurrentLocation().then((value) {
      futureWhat3Words = fetchWhat3Words(
        value.latitude.toString(),
        value.longitude.toString(),
      );
    });
  }

  DateTime reminderTime = DateTime.now();
  int reminderUnixTime = 0000;

  Widget dateTimePicker() {
    return CupertinoDatePicker(
      initialDateTime: DateTime.now().add(Duration(hours: 1)),
      onDateTimeChanged: (DateTime dateTime) {
        print(dateTime);
        reminderTime = dateTime;
        getUnixTime(reminderTime);
        setState(() {});
      },
      mode: CupertinoDatePickerMode.dateAndTime,
      minuteInterval: 1,
      minimumDate: DateTime.now()
    );
  }

  getUnixTime (DateTime reminderTime) {
    print(reminderTime);
    reminderUnixTime = reminderTime.millisecondsSinceEpoch ~/ 1000;
  }

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                TextFieldWidget("Task title", 30, controller1),
                TextFieldWidget("Task description", 100, controller2),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: FutureBuilder<What3Words>(
              future: futureWhat3Words,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  print(snapshot.data.words);
                  return Column(
                    children: <Widget>[
                      Material(
                          child: Text(
                        'W3W Location: ' + snapshot.data.words,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )),
                       PlatformButton(
                        child: Text("Get location"),
                        onPressed: () async {
                          futureWhat3Words = null;
                          setState(() {});
                          //Makes futureW3W null, so the CircularProgressIndicator appears
                          _displayCurrentLocation().then((value) {
                            futureWhat3Words = fetchWhat3Words(
                                value.latitude.toString(),
                                value.longitude.toString());
                          });
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
                // By default, show a loading spinner.
              },
            ),
          ),
          Card(
            child: Row(
              children: <Widget>[
                CupertinoButton(
                  child: Text("Set task reminder time"),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: dateTimePicker(),
                          );
                        });
                  },
                ),
                Material(child: Text(new DateFormat('yMMMMd').add_jm().format(reminderTime))),
              ],
            ),
          ),
          FlatButton(
            onPressed: () async {
              print("whats going on");
              Task newTask = Task(
                heading: controller1.text,
                context: controller2.text,
                due: reminderUnixTime,
                status: false,
              );
              print(newTask.heading);
              await DBProvider.db.newTask(newTask);
              setState(() {});
              print("Added " + controller1.text + " and " + controller2.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
