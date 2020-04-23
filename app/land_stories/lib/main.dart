import 'package:flutter/material.dart';

import './widgets/fancyFab.dart';
import './widgets/StoryView.dart';
import './widgets/sliverHeader.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverHeader(),
          ];
        },
        body: StoryView(),
      ),
      floatingActionButton: FancyFab(),
    );
  }
}