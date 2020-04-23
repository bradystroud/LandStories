import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';




class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _currentSwitchValue = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Settings"),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Card(
              child: Container(
                child: ListTile(
                  leading: Text(
                    "Very important setting",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: CupertinoSwitch(
                    value: _currentSwitchValue,
                    onChanged: (value) {
                      print("switch flipped: " + _currentSwitchValue.toString());
                      setState(() {
                        _currentSwitchValue = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            PlatformButton(
              child: Text("Feedback"),
              onPressed: () {

                _showDialouge();
              },
            )
          ],
        ),
      ),
    );
  }

  void _showDialouge() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
          title: Text("Feedback"),
          content: Text("Help me improve the app by sending me some feedback."),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: () {null;}
              // onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
