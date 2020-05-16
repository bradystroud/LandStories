import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class IdentifyWeeds extends StatefulWidget {
  @override
  _IdentifyWeedsState createState() => _IdentifyWeedsState();
}

class _IdentifyWeedsState extends State<IdentifyWeeds> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Identify Weeds"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // TODO: Questions
          ],
        ),
      ),
    );
  }
}
