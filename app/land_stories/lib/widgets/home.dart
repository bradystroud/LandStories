import 'package:flutter/material.dart';
import 'package:land_stories/widgets/fancyFab.dart';

import 'StoryView.dart';
import 'coolHeader.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[CoolHeader()];
        },
        body: StoryView(),
      ),
      floatingActionButton: FancyFab(),
    );
    
  }
}
