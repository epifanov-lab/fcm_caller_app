import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/utils/ui_utils.dart';
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

  Future<User> updateState(List<User> users, user) {
    users.remove(user);
    users.insert(0, user);
    setState(() {
      _user = user;
      _allUsers = users;
    });
    return Future.value(user);
  }

  Future refresh() {
    return client.getUsers().then((users) => updateState(users, _user));
  }

  void _onTapUser(User from, User to) => client.call(from, to)
      .then((_) => Navigator.pushNamed(context, '/callSend', arguments: _user));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _widgetUsersList(),
            _widgetUpdateButton(),
          ],
        ),
      ),);
  }

  //TODO: StreamBuilder _firestore.collection('users').snapshots().listen(...)
  Center _widgetUsersList() {
    return Center(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: _allUsers.length,
              itemBuilder: (context, index) =>
              index == 0 ? _widgetTopUser() : _widgetUserContact(_allUsers[index]),
              separatorBuilder: (context, index) => _widgetListSeparator(index),
            ),);
  }

  Widget _widgetTopUser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 32),
        AvatarWidget(_user.name, 64, onTap: () => _onTapUser(_user, _user)),
        _widgetEditableUserName(_user),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _widgetEditableUserName(User user) {
    return InkWell(
      onTap: () => { /*todo change name */ },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 16),
            Text(user.name, style: appTheme.textTheme.headline1),
            SizedBox(width: 8),
            Image.asset('assets/icons/ic_edit.png', scale: 2.5, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _widgetUserContact(User user) {
    return user == STUB_USER ? _widgetStubContact()
        : InkWell(onTap: () => _onTapUser(_user, user),
            child: Row(children: <Widget>[
              SizedBox(width: 16),
              AvatarWidget(user.name, 48),
              SizedBox(width: 16),
              Text(user.name, style: appTheme.textTheme.headline2,)
      ],),);
  }

  Widget _widgetStubContact() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
          'Список доступных для звонка контактов пуст. '
          'Установите приложение на другие устройства. '
          'Проверьте подключение к сети.',
          style: appTheme.textTheme.subtitle2),
    );
  }

  Widget _widgetUpdateButton() {
    return Positioned(bottom: 32, right: 32,
      child: UiUtils.widgetCircleButton(48, Colors.blueGrey,
        'assets/icons/ic_refresh.png', 2, Colors.white,
        () => refresh())
    );
  }

  Widget _widgetListSeparator(int index) {
    return index > 0 ? SizedBox(height: 16) : Container(
      child: Text('Контакты:', style: appTheme.textTheme.subtitle1, textAlign: TextAlign.center),
    );
  }

}
