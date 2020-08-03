import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';

import '../Database/getW3W.dart';
import '../Database/Database.dart';
import '../Database/Models.dart';
import '../widgets/textField.dart';

class NewTask extends StatefulWidget {

  final Function callback;

  NewTask(this.callback);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.blue,
      appBar: PlatformAppBar(
          title: Text(
            "New Task",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white),
      body: NewTaskDetails(widget.callback),
    );
  }
}

class NewTaskDetails extends StatefulWidget {
  final Function callback;

  NewTaskDetails(this.callback);

  @override
  _NewTaskDetailsState createState() => _NewTaskDetailsState();
}

class _NewTaskDetailsState extends State<NewTaskDetails> {
  DateTime reminderTime = DateTime.now();
  int reminderUnixTime = 0000;

  Widget dateTimePicker() {
    return CupertinoDatePicker(
      backgroundColor: Colors.white,
      initialDateTime: DateTime.now().add(Duration(hours: 1)),
      onDateTimeChanged: (DateTime dateTime) {
        print(dateTime);
        reminderTime = dateTime;
        getUnixTime(reminderTime);
        setState(() {});
      },
      mode: CupertinoDatePickerMode.dateAndTime,
      minuteInterval: 1,
      minimumDate: DateTime.now(),
    );
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
                                  height: MediaQuery.of(context).copyWith().size.height / 3,
                                  child: dateTimePicker(),
                                );
                              });
                        },
                      ),
                      Text(
                        new DateFormat('yMMMMd').add_jm().format(reminderTime),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            color: Colors.white,
            onPressed: () async {
              widget.callback("");
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
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
