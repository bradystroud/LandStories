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
          title: Text("New Task", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.grey
        ),
        body: NewTaskDetails());
  }
}

class NewTaskDetails extends StatefulWidget {
  @override
  _NewTaskDetailsState createState() => _NewTaskDetailsState();
}

class _NewTaskDetailsState extends State<NewTaskDetails> {

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
        minimumDate: DateTime.now());
  }

  getUnixTime(DateTime reminderTime) {
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                W3WLocation(),
                Card(
                  child: Row(
                    children: <Widget>[
                      CupertinoButton(
                        child: Text("Set reminder time"),
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
                      Material(
                          child: Text(new DateFormat('yMMMMd')
                              .add_jm()
                              .format(reminderTime))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () async {
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
              setState(() {
                
              });
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
