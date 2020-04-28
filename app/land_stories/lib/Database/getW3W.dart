import 'dart:async';
import 'dart:convert';

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
