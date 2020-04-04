import 'package:fcmcallerapp/entities/user.dart';
import 'package:flutter/material.dart';

import '../test_utils.dart';

class TestUsersAndAvatars extends StatelessWidget {
  static final String title = 'users & avatars';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('ui-test-zone: $title')),
        body: testUsersAndAvatars(50)
    );
  }

  Center testUsersAndAvatars(int count) {
    List<User> users = TestUtils.getRandomUsers(count);
    return Center(
      child: ListView(
          children: TestUtils.getUserTextWidgetsList(users)
      ),
    );
  }
}
