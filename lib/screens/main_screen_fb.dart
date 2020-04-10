import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/utils/ui_utils.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_main.dart';
import '../theme.dart';

class MainScreenFb extends StatefulWidget {
  @override
  _MainScreenFbState createState() => _MainScreenFbState();
}

class _MainScreenFbState extends State<MainScreenFb> {

  User _user = STUB_USER;
  List<User> _allUsers = List();

  @override
  void initState() {
    updateUsers();
    super.initState();
  }

  Future updateUsers() {
    return fcm.initialize().then((token) {
      print('@@@@@ fcmService.initialize: $token');
      return firestore.getUsers().then((users) {
        return checkIsRegistered(token, users) ? updateState(users, _user) :
          firestore.register(User.generate(token))
            .then((user) => updateState(users, user));
      });
    });
  }

  bool checkIsRegistered(String token, List<User> users) {
    bool result = false;
    users.forEach((user) {
      if (token == user.token) {
        result = true; _user = user;
      }});
    print('@@@@@ checkIsRegistered: $result $_user');
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
    return firestore.getUsers().then((users) => updateState(users, _user));
  }

  void _onTapUser(User from, User to) => fcm.call(from, to)
      .then((_) => Navigator.pushNamed(context, '/callSend', arguments: _user));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _widgetUsersList(),
            _widgetRefreshButton(),
          ],
        ),
      ),);
  }

  //TODO: StreamBuilder _firestore.collection('users').snapshots().listen(...)
  Center _widgetUsersList() {
    return Center(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _allUsers.length,
              itemBuilder: (context, index) =>
                index == 0 ? _widgetTopUser() : _widgetUserContact(_allUsers[index]),
            ),);
  }

  Widget _widgetTopUser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 32),
        AvatarWidget(_user.name, 80, onTap: () => _onTapUser(_user, _user)),
        SizedBox(height: 8),
        _widgetEditableUserName(_user),
        SizedBox(height: 16),
        Text('Контакты:', style: appTheme.textTheme.subtitle1, textAlign: TextAlign.center),
        _allUsers.length == 1 ? _widgetStubContact() : Container()
      ],
    );
  }

  Widget _widgetEditableUserName(User user) {
    return InkWell(
      onTap: () => UiUtils.dialogEditText(context, _user.name)
          .then((result) {
            if (result != null) {
              setState(() => _user.name = result);
              return firestore.rename(_user);
            } else return Future.value(null);
          }),
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
    return InkWell(onTap: () => _onTapUser(_user, user),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(children: <Widget>[
                SizedBox(width: 16),
                AvatarWidget(user.name, 48),
                SizedBox(width: 16),
                Text(user.name, style: appTheme.textTheme.headline2,)
      ],),
            ),);
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

  Widget _widgetRefreshButton() {
    return Positioned(bottom: 32, right: 32,
      child: UiUtils.widgetCircleButton(56, colorAccent,
        'assets/icons/ic_refresh.png', 2.2, Colors.white,
        () => refresh())
    );
  }

}
