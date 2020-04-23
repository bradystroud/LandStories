import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void showDialouge(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Feedback"),
          content: Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: () {}
            ),
          ],
        );
      },
    );
  }