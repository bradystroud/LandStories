import 'package:flutter/material.dart';

import '../Database/Database.dart';
import '../Database/Models.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Story item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      child: Card(
        color: Colors.blueAccent,
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
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  const TaskCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Task item;

  @override
  _TaskCardState createState() => _TaskCardState(item);
}

class _TaskCardState extends State<TaskCard> {
  bool test = false;
  Task item;

  Color checkDueDate(dueDate) {
    // determines if the card should be red or blue depending on its completion status
    if (dueDate > DateTime.now().millisecondsSinceEpoch / 1000) {
      return Colors.blueAccent;
    } else if (item.status) {
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
          //TODO: modify for tasks needs to be built
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
            child: Padding(
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
                      activeColor: Colors.lightBlueAccent,
                      onChanged: (bool newValue) {
                        DBProvider.db.changeStatus(item);
                        setState(
                          () {
                            item.status = newValue;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
