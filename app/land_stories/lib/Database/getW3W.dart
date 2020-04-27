import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(lat, long) async {
  final response = await http.get(
      'https://api.what3words.com/v3/convert-to-3wa?coordinates=' +
          lat +
          ',' +
          long +
          '2&language=en&key=6U7VA8V0');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    print("bad");
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String words;

  Album({this.words});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      words: json['words'],
    );
  }
}
