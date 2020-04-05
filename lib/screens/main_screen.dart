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

  User _user = STUB_USER;
  List<User> _allUsers = List();

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
            setState(() => _user = User.generate(token));
            storage.set('user', _user.toJson());
            return client.register(_user);
          } else {
            setState(() => _user = User.fromJson(json.decode(storage.get('user'))));
            return Future.value(null);
          }
        });
  }

  Future updateAllUsers() {
    return client.users().then((users) {
      if (users.isEmpty) users..add(_user)..add(STUB_USER);
      else if (users.length == 1 && users.contains(_user)) users.add(STUB_USER);
      else {
        if (users.indexOf(_user) >= 0) users..remove(_user)..insert(0, _user);
        else users.insert(0, STUB_USER);
      }
      setState(() => _allUsers = users);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build: ${_allUsers.length}');
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: Center(
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: _allUsers.length,
          itemBuilder: (context, index) =>
                        index == 0 ? ownInfoBlock() : getUserWidget(_allUsers[index]),
          separatorBuilder: (context, index) => SizedBox(height: 16),
    ),),);
  }
  
  Widget ownInfoBlock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            AvatarWidget(_user.name, 64),
            SizedBox(height: 16),
            Text(_user != STUB_USER ? _user.name : '... ...',
                style: appTheme.textTheme.headline1),
            SizedBox(height: 32),
            Text('нажмите для вызова:', style: appTheme.textTheme.subtitle1)
        ],
      ),
    );
  }

  Widget getUserWidget(User user) {
    return user == STUB_USER ? contactsStub() :
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/call', arguments: user),
          child: Row(children: <Widget>[
            SizedBox(width: 16),
            AvatarWidget(user.name, 48),
            SizedBox(width: 16),
            Text(user.name, style: appTheme.textTheme.headline2,)],
          ),
        );
  }

  Widget contactsStub() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
          'Список доступных для звонка контактов пуст. '
          'Установите приложение на другие устройства. '
          'Проверьте подключение к сети.',
          style: appTheme.textTheme.subtitle2),
    );
  }

}
