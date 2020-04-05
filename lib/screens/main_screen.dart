import 'dart:convert';

import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app.dart';
import '../theme.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  User user = STUB_USER;
  List<User> allUsers = List();

  @override
  void initState() {
    updateUser().then((_) => updateAllUsers());
    super.initState();
  }

  //TODO: переписать на RxDart
  Future updateUser() async {
    return fcmService.initialize()
        .then((token) {
          print('@@@@@ f.FcmService TOKEN: $token');
          if (storage.get('user') == null) {
            setState(() => user = User.generate(token));
            storage.set('user', user.toJson());
            return client.register(user);
          } else {
            setState(() => user = User.fromJson(json.decode(storage.get('user'))));
            return Future.value(null);
          }
        });
  }

  Future updateAllUsers() {
    return client.users().then((users) {
      if (users.isEmpty) users..add(user)..add(STUB_USER);
      else if (users.length == 1 && users.contains(user)) users.add(STUB_USER);
      else {
        if (users.indexOf(user) >= 0) users..remove(user)..insert(0, user);
        else users.insert(0, STUB_USER);
      }
      setState(() => allUsers = users);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build: ${allUsers.length}');
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: Center(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: allUsers.length,
          itemBuilder: (BuildContext context, int index) {
            User current = allUsers[index];
            return index == 0 ? ownInfoBlock(current) : getUserWidget(current);
          },
    ),),);
  }
  
  Widget ownInfoBlock(User user) {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            AvatarWidget(user.name, 64),
            SizedBox(height: 16),
            Text(user != STUB_USER ? user.name : '... ...',
                style: appTheme.textTheme.headline1),
            SizedBox(height: 32),
            Text('Tap to call:', style: appTheme.textTheme.subtitle1)
        ],
      ),
    );
  }

  Widget getUserWidget(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
      child: user != STUB_USER ? Row(children: <Widget>[
        AvatarWidget(user.name, 48),
        SizedBox(width: 16),
        Text(user.name, style: appTheme.textTheme.headline2,)],
      ) : contactsStub(),
    );
  }

  Widget contactsStub() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Text(
          'Список доступных для звонка контактов пуст. '
          'Установите приложение на другие устройства. '
          'Проверьте подключение к сети.',
          style: appTheme.textTheme.subtitle2),
    );
  }

}
