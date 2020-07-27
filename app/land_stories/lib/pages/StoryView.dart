import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:land_stories/widgets/StoryViewCards.dart';
import 'package:land_stories/widgets/heading.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../Database/Database.dart';
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
        Heading("Stories"),
        FutureHScrollList(true),
        Heading("Tasks"),
        FutureHScrollList(false),
        RaisedButton(
          onPressed: () {
            setState(() {});
          },
        )
      ],
    );
  }
}

class FutureHScrollList extends StatefulWidget {
  //Horizontal scrolling list
  final bool isAStory;

  FutureHScrollList(this.isAStory);

  @override
  _FutureHScrollListState createState() => _FutureHScrollListState(isAStory);
}

class _FutureHScrollListState extends State<FutureHScrollList> {
  int _focusedIndex = 0;
  bool isAStory;

  _FutureHScrollListState(this.isAStory);

  void _onItemFocus(int index) {
    HapticFeedback.selectionClick(); //Pointless but fun :)

    setState(() {
      _focusedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: isAStory ? DBProvider.db.getAllStories() : DBProvider.db.getAllTasks(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.toString() == "[]") {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("You don't have any tasks. Tap the +  below to add one."),
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
                        return widget.isAStory
                            ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Modify(snapshot.data[index]),
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: StoryCard(item: snapshot.data[index]),
                                ),
                              )
                            : TaskCard(item: snapshot.data[index]);
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