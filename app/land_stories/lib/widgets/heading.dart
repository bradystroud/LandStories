import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String heading;

  Heading(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              margin: EdgeInsets.only(right: 200.0),
              width: 110.0,
              height: 55.0,
              child: Container(
                child: Center(
                    child: Text(
                  heading,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                )),
                decoration: new BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
