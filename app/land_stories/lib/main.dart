import 'package:flutter/material.dart';

import './widgets/fancyFab.dart';
import './pages/StoryView.dart';
import './widgets/sliverHeader.dart';

void main() => runApp(
      //Main function
      MaterialApp(
        // darkTheme: darkTheme: ThemeData.dark(),,
        theme: new ThemeData(
          //Theme data for the app
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF212121),
          accentColor: const Color(0xFF64ffda),
          canvasColor: const Color(0xFF303030),
        ),
        home: LandStoriesHome(), //Home page of the app
      ),
    );

class LandStoriesHome extends StatefulWidget {
  @override
  _LandStoriesHomeState createState() => _LandStoriesHomeState();
}

class _LandStoriesHomeState extends State<LandStoriesHome> {
  FancyFab newStory;

  String abc;

  @override
  void initState() {
    super.initState();
    //
  }

  callback(newAbc) {
    setState(() {
      abc = newAbc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        //This is part of the scrolling gradient header
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverHeader(callback),
          ];
        },
        body: StoryView(), //View with stories and tasks. The body of the app
      ),
      floatingActionButton:
          FancyFab(callback: callback), //The Floating action button with animations
    );
  }
}
