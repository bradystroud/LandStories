import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

Future<What3Words> fetchWhat3Words(lat, long) async {
  final response = await http.get(
      'https://api.what3words.com/v3/convert-to-3wa?coordinates=' +
          lat +
          ',' +
          long +
          '2&language=en&key=6U7VA8V0');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return What3Words.fromJson(json.decode(response.body));
  } else {
    print("bad");
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load What3Words');
  }
}

class What3Words {
  final String words;

  What3Words({this.words});

  factory What3Words.fromJson(Map<String, dynamic> json) {
    return What3Words(
      words: json['words'],
    );
  }
}

class W3WLocation extends StatefulWidget {
  @override
  _W3WLocationState createState() => _W3WLocationState();
}

class _W3WLocationState extends State<W3WLocation> {
  Future<What3Words> futureWhat3Words;

  Future<Position> _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    setState(() {});
    return location;
  }

  @override
  void initState() {
    super.initState();
    _displayCurrentLocation().then((value) {
      futureWhat3Words = fetchWhat3Words(
        value.latitude.toString(),
        value.longitude.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<What3Words>(
      future: futureWhat3Words,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          print(snapshot.data.words);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: '/// ',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'W3W Location: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                          text: snapshot.data.words,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  // FlatButton(
                  //   child: Text("Get location"),
                  //   onPressed: () async {
                  //     futureWhat3Words = null;
                  //     //Makes futureW3W null, so the CircularProgressIndicator appears
                  //     _displayCurrentLocation().then((value) {
                  //       futureWhat3Words = fetchWhat3Words(
                  //           value.latitude.toString(),
                  //           value.longitude.toString());
                  //     });
                  //     setState(() {
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
        // By default, show a loading spinner.
      },
    );
  }
}
