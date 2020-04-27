import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ScrollSnapList(
                      itemSize: 220,
                      onItemFocus: _onItemFocus,
                      scrollDirection: Axis.horizontal,
                      //TODO: Need to make horizontal scrolling list
                      // separatorBuilder: (context, index) => Divider(
                      //   color: Colors.grey,
                      //   thickness: 0.15,
                      //   indent: 10,
                      //   endIndent: 10,
                      // ),
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
                                    //TODO: This widget was taken from another project. it was originally used as a traditional vertical scrolling view. I need to get all the functionality from the commented out sections onto this Horizontal scroll view. ListView() doesnt like horizontal scrolling but still accepts the parameter.
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
                                              ), //TODO: bold doesnt work on ipad on current os versions
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
