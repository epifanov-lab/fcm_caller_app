import 'package:fcmcallerapp/theme.dart';
import 'package:flutter/material.dart';

import 'test_main.dart';

class TestWssService extends StatelessWidget {
  static final String title = 'wss service';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('test-zone: $title')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: wss.changes,
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                else if (!(snapshot.data is Map)) return Container();
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
