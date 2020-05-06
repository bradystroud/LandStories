import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        Heading("Stories"),
        FutureVScrollList(true),
        Heading("Tasks"),
        FutureVScrollList(false),
      ],
    );
  }
}

class FutureVScrollList extends StatefulWidget {
  final bool isStory;

  FutureVScrollList(this.isStory);

  @override
  _FutureVScrollListState createState() => _FutureVScrollListState(isStory);
}

class _FutureVScrollListState extends State<FutureVScrollList> {
  int _focusedIndex = 0;
  bool isStory;

  _FutureVScrollListState(this.isStory);

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isStory);
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
                        itemSize: 220,
                        onItemFocus: _onItemFocus,
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
                                  );
                                },
                                child: Container(
                                  width: 220,
                                  child: Card(
                                    color: Colors.blueAccent,
                                    child: Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 180,
                                              child: Text(
                                                item.heading,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 180,
                                              child: Text(item.context),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // IconButton(
                                      //   onPressed: () {
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) => Modify(item),
                                      //       ),
                                      //     );
                                      //   },
                                      //   icon: Icon(
                                      //     Icons.info,
                                      //   ),
                                      // ),
                                    ]),
                                  ),
                                ),
                              )

                              // leading: Checkbox(
                              //   onChanged: (bool value) {
                              //     DBProvider.db.changeStatus(item);
                              //     print("status for " +
                              //         item.heading +
                              //         " is changed: " +
                              //         item.status.toString());
                              //     setState(() {});
                              //   },
                              //   value: item.status,
                              // ),
                              // onTap: () {
                              //   DBProvider.db.changeStatus(item);
                              //   print("status for " +
                              //       item.heading +
                              //       " is changed: " +
                              //       item.status.toString());
                              //   setState(() {});
                              // },
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
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ScrollSnapList(
                        itemSize: 220,
                        onItemFocus: _onItemFocus,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Task item = snapshot.data[index];
                          return TaskCard(item);
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

class TaskCard extends StatefulWidget {
  final Task item;

  TaskCard(this.item);
  @override
  _TaskCardState createState() => _TaskCardState(item);
}

class _TaskCardState extends State<TaskCard> {

  Task item;

  Color checkDueDate(dueDate) {
    if(dueDate > DateTime.now().millisecondsSinceEpoch / 1000){
      return Colors.blueAccent;
    } else {
      return Colors.red;
    }
  }

  _TaskCardState(this.item);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          //TODO: modify for tasks
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Modify(item),
          //   ),
          // );
        },
        child: Container(
          width: 220,
          child: Card(
            color: checkDueDate(item.due),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 180,
                      child: Text(
                        item.heading,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: Text(item.context),
                    ),
                    Container(
                      child: Checkbox(
                        value: item.status,
                        onChanged: (bool value) {
                          DBProvider.db.changeStatus(item);
                          print("status for " +
                              item.heading +
                              " is changed: " +
                              item.status.toString());
                          setState(() {value;
                          item.status;});
                        },
                      ),
                    ),
                    Text(item.due.toString()),
                  ],
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => Modify(item),
              //       ),
              //     );
              //   },
              //   icon: Icon(
              //     Icons.info,
              //   ),
              // ),
            ]),
          ),
        ),
      ),

      // leading: Checkbox(
      //   onChanged: (bool value) {
      //     DBProvider.db.changeStatus(item);
      //     print("status for " +
      //         item.heading +
      //         " is changed: " +
      //         item.status.toString());
      //     setState(() {});
      //   },
      //   value: item.status,
      // ),
      // onTap: () {
      //   DBProvider.db.changeStatus(item);
      //   print("status for " +
      //       item.heading +
      //       " is changed: " +
      //       item.status.toString());
      //   setState(() {});
      // },
    );
  }
}
