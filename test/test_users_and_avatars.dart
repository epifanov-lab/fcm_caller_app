import 'package:fcmcallerapp/app.dart';
import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/material.dart';

import 'test_utils.dart';

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
          padding: EdgeInsets.all(16),
          children: getUserTextWidgetsList(users),
      ),
    );
  }

  List<Widget> getUserTextWidgetsList(List<User> users) {
    List<Widget> result = List();
    users.forEach((user) {
      result.add(getUserWidget(user));
      result.add(SizedBox(height: 16));
    });
    return result;
  }

  Widget getUserWidget(User user) {
    return Row(children: <Widget>[
      AvatarWidget(user.name, 36),
      SizedBox(width: 16),
      Text(user.name, style: Style.appTheme.textTheme.headline2,)],
    );
  }

}
