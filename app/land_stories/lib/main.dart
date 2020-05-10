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
    home: LandStories()));

class LandStories extends StatefulWidget {
  @override
  _LandStoriesState createState() => _LandStoriesState();
}

class _LandStoriesState extends State<LandStories> {
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
