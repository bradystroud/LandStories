import 'package:flutter/material.dart';

import './widgets/fancyFab.dart';
import './pages/StoryView.dart';
import './widgets/sliverHeader.dart';

void main() => runApp(MaterialApp(
  // darkTheme: darkTheme: ThemeData.dark(),,
    theme: new ThemeData(
      brightness: Brightness.dark,
      
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF212121),
      accentColor: const Color(0xFF64ffda),
      canvasColor: const Color(0xFF303030),
    ),
    home: LandStoriesHome()));

class LandStoriesHome extends StatefulWidget {
  @override
  _LandStoriesHomeState createState() => _LandStoriesHomeState();
}

class _LandStoriesHomeState extends State<LandStoriesHome> {
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
