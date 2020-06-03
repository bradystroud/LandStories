import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:land_stories/widgets/StoryViewCards.dart';
import 'package:land_stories/widgets/heading.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../Database/Database.dart';
import '../Database/Models.dart';
import '../pages/modify.dart';

class StoryView extends StatefulWidget {
  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // FlatButton(
        //   onPressed: () {
        //     setState(() {});
        //   },
        //   child: Text("Set State"),
        // ),
        Heading("Stories"),
        FutureHScrollList(true),
        Heading("Tasks"),
        FutureHScrollList(false),
      ],
    );
  }
}

class FutureHScrollList extends StatefulWidget {
  //Horizontal scrolling list
  final bool isStory;

  FutureHScrollList(this.isStory);

  @override
  _FutureHScrollListState createState() => _FutureHScrollListState(isStory);
}

class _FutureHScrollListState extends State<FutureHScrollList> {
  int _focusedIndex = 0;
  bool isStory;

  _FutureHScrollListState(this.isStory);

  void _onItemFocus(int index) {
    HapticFeedback.selectionClick(); //Pointless but fun :)

    setState(() {
      _focusedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isStory) {
      return FutureBuilder<List<Story>>(
        future: DBProvider.db.getAllStories(),
        builder: (BuildContext context, AsyncSnapshot<List<Story>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.toString() == "[]") {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        "You don't have any stories. Tap the +  below to add one."),
                  ),
                ],
              ));
            } else {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ScrollSnapList(
                        itemSize: 230,
                        onItemFocus: _onItemFocus,
                        dynamicItemSize: true,
                        updateOnScroll:
                            true, //Probably a big power draw, but feels awesome
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Story item = snapshot.data[index];
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Modify(item),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child: StoryCard(item: item),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          } else {
            return Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      );
    } else {
      //Same as above, just tasks not stories.
      return FutureBuilder<List<Task>>(
        future: DBProvider.db.getAllTasks(),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.toString() == "[]") {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        "You don't have any tasks. Tap the +  below to add one."),
                  ),
                ],
              ));
            } else {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                      child: ScrollSnapList(
                        itemSize: 230,
                        dynamicItemSize: true,
                        focusOnItemTap: true,
                        updateOnScroll: true,
                        onItemFocus: _onItemFocus,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Task item = snapshot.data[index];
                          return TaskCard(item: item);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          } else {
            return Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      );
    }
  }
}
