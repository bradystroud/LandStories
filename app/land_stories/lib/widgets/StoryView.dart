import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:land_stories/widgets/heading.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../Database/Database.dart';
import '../Database/StoryModel.dart';
import '../pages/modify.dart';

class StoryView extends StatefulWidget {
  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  int _focusedIndex = 0;

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
       Heading("Stories"),
        FutureVScrollList(),
        Heading("Tasks"),
        FutureVScrollList(),
      ],
    );
  }
}

class FutureVScrollList extends StatefulWidget {
  @override
  _FutureVScrollListState createState() => _FutureVScrollListState();
}

class _FutureVScrollListState extends State<FutureVScrollList> {
    int _focusedIndex = 0;

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
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
  }
}