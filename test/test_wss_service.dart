import 'package:fcmcallerapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'test_main.dart';

class TestWssService extends StatefulWidget {
  static final String title = 'wss service';

  @override
  _TestWssServiceState createState() => _TestWssServiceState();
}

class _TestWssServiceState extends State<TestWssService> {

  @override
  void initState() {
    runWssTest();
    super.initState();
  }

  void runWssTest() {
    Observable.range(0, 20) //todo не то
        .delay(Duration(seconds: 2))
        .listen((number) => wss.sendMessage('message $number'));

    wss.events().listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('test-zone: ${TestWssService.title}')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: wss.states,
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                else if (!snapshot.hasData) return Container();
                else return ListView.builder(
                    itemCount: snapshot.data.keys.length,
                    itemBuilder: (context, index) =>
                        Text('${snapshot.data.keys.elementAt(index)}: '
                            '${snapshot.data.values.elementAt(index)}',
                        style: appTheme.textTheme.headline2)
                );
              },
            ),
          ),
        )
    );
  }
}
