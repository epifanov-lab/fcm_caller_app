import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/theme.dart';
import 'package:fcmcallerapp/services/thrash/client.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/material.dart';

class TestUsersAndAvatars extends StatelessWidget {
  static final String title = 'users & avatars';

  @override
  Widget build(BuildContext context) {
    List<User> users = StubClient.getRandomUsers(50);
    return Scaffold(
        appBar: AppBar(title: Text('test-zone: $title')),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: getUserTextWidgetsList(users),
          ),
        )
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
      Text(user.name, style: appTheme.textTheme.headline2,)],
    );
  }

}
