import 'package:flutter/material.dart';

import '../Database/getFloraFauna.dart';
// https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

class FloraFaunaPage extends StatefulWidget {
  @override
  _FloraFaunaPageState createState() => _FloraFaunaPageState();
}

class _FloraFaunaPageState extends State<FloraFaunaPage> {
  Future<FloraFauna> futureFloraFauna;

  @override
  void initState() { //This function runs when the page builds
    super.initState();
    futureFloraFauna = fetchFloraFauna(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Flora and Fauna Data'),
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FutureBuilder<FloraFauna>(
                future: futureFloraFauna, //Future value
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.kingdom.toString(), //List of 
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) { //If their was an error, this condition would be true
                    return Text("${snapshot.error}"); //returns error messages
                  }
                  return CircularProgressIndicator(); // By default, show a loading spinner.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
