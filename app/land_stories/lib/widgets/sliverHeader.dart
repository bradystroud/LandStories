import 'package:flutter/material.dart';

import '../pages/SettingsPage.dart';

class SliverHeader extends StatelessWidget {
  final Function callback;

  SliverHeader(this.callback);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 130.0,
      floating: false,
      pinned: true,
      leading: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(callback),
            ),
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Land Stories",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[500],
                Colors.indigo[300],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
