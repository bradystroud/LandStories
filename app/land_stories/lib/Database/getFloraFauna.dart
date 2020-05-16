import 'dart:async';
import 'dart:convert';


import 'package:http/http.dart' as http;

Future<FloraFauna> fetchFloraFauna() async {
  final response =
      await http.get('https://apps.des.qld.gov.au/species/?op=getkingdomnames&f=json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return FloraFauna.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load FloraFauna');
  }
}

class FloraFauna {
  final List kingdomName;
  final List kingdom;


  FloraFauna({this.kingdomName, this.kingdom});

  factory FloraFauna.fromJson(Map<String, dynamic> json) {
    return FloraFauna(
      kingdom: json['Kingdom'],
      
    );
  }
}