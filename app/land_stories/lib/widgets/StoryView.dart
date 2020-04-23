import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widgets/newStory.dart';
import '../Database/Database.dart';
import '../Database/StoryModel.dart';
import './modify.dart';

class StoryView extends StatefulWidget {
  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
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
            return ListView.separated(
              scrollDirection: Axis.vertical, //Need to make horizontal scrolling list
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                thickness: 0.15,
                indent: 10,
                endIndent: 10,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Story item = snapshot.data[index];
                return Padding(
                  padding: const EdgeInsets.only(),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.heading,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight
                                  .bold), //bold doesnt work on ipad on current versions
                        ),
                        Text(item.context)
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Modify(item),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.info,
                      ),
                    ),
                    leading: Checkbox(
                      onChanged: (bool value) {
                        DBProvider.db.changeStatus(item);
                        print("status for " +
                            item.heading +
                            " is changed: " +
                            item.status.toString());
                        setState(() {});
                      },
                      value: item.status,
                    ),
                    onTap: () {
                      DBProvider.db.changeStatus(item);
                      print("status for " +
                          item.heading +
                          " is changed: " +
                          item.status.toString());
                      setState(() {});
                    },
                  ),
                );
              },
            );
          }
        } else {
          return Center(
              child: Row(
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ));
        }
      },
    );
  }
}
