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
    updateUsers();
    super.initState();
  }

  Future updateUsers() {
    return fcmService.initialize().then((token) {
      return client.getUsers().then((users) {
        return checkIsRegistered(token, users) ? updateState(users, _user) :
          client.register(User.generate(token))
            .then((user) => _user = user)
            .then((_) => client.getUsers())
            .then((users) => updateState(users, _user));
      });
    });
  }

  bool checkIsRegistered(String token, List<User> users) {
    bool result = false;
    users.forEach((user) {
      if (token == user.token) {
        result = true; _user = user;
      }});
    return result;
  }

  Future updateState(List<User> users, user) {
    users..remove(user)..insert(0, user);
    setState(() {
      _user = user;
      _allUsers = users;
    });
    return Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    print('build: ${_allUsers.length}');
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: SafeArea(
        child: Center(
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: _allUsers.length,
            itemBuilder: (context, index) =>
                          index == 0 ? ownInfoBlock() : getUserWidget(_allUsers[index]),
            separatorBuilder: (context, index) {
              return index == 0 ? Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16),
                    Text('Контакты:', style: appTheme.textTheme.subtitle1)
                  ],
                ),
              ) : SizedBox(height: 16);
            },
        ),),
      ),);
  }
  
  Widget ownInfoBlock() {
    return InkWell(
      onTap: () => client.callAll(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 32),
          AvatarWidget(_user.name, 64),
            SizedBox(height: 16),
            Text(_user != STUB_USER ? _user.name : '... ...',
                style: appTheme.textTheme.headline1),
            SizedBox(height: 32),
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
