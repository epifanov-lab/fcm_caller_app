import 'dart:async';

import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/utils/ui_utils.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../theme.dart';

class MainScreenWss extends StatefulWidget {
  @override
  _MainScreenWssState createState() => _MainScreenWssState();
}

class _MainScreenWssState extends State<MainScreenWss> {

  User _user = STUB_USER;
  List<User> _allUsers = List();

  List<StreamSubscription> _subscriptions = List();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    super.dispose();
  }

  void initialize() {
    updateUser()
        .then((user) => wss.setUser(user))
        .then((_) => _subscriptions.add(listenWsEvents()));
  }

  Future<User> updateUser() {
    return fcm.initialize().then((token) {
      print('@@@@@ fcmService.initialize: $token');
      return firestore.getUsers().then((users) {
        return checkIsRegistered(token, users) 
            ? Future.value(_user) : registerNewUser(token);
      });
    });
  }

  bool checkIsRegistered(String token, List<User> users) {
    bool result = false;
    users.forEach((user) {
      if (token == user.token) {
        result = true;
        setState(() => _user = user);
      }});
    print('@@@@@ checkIsRegistered: $result $_user');
    return result;
  }

  Future<User> registerNewUser(String token) {
    setState(() => _user = User.generate(token));
    return firestore.register(_user);
  }

  StreamSubscription listenWsEvents() {
    return wss.data.listen((map) {
      if (map['event'] == 'get users list') {
        List rawUsers = (map['data']['push'] as List);
        rawUsers.addAll(map['data']['ws'] as List);
        setState(() {
          _allUsers = rawUsers.map((raw) => User.fromJson(raw)).toList()..remove(_user);
        });
      } else if (map['event'] == 'get call') {
        Navigator.pushNamed(context, '/callReceive', arguments: User.fromJson(map['data']));
      }
    });
  }

  Future<void> refresh() {
    return wss.sendMessage('get users list', null)
        .catchError((error) { /* todo show error */ });
  }

  void _onTapUser(User from, User to)
      => wss.sendMessage('send call', to.id)
      .then((_) => Navigator.pushNamed(context, '/callSend', arguments: to))
      .catchError((error) { /* todo show error */ });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _widgetTopUser(),
            Padding(
                padding: EdgeInsets.only(top: 196),
                child: _widgetUsersList()),
            Positioned(bottom: 32, right: 32, child:
            _widgetRefreshButton()),
          ],
        ),
      ),);
  }

  Widget _widgetTopUser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 32),
        AvatarWidget(_user.name, 80, onTap: () => _onTapUser(_user, _user)),
        SizedBox(height: 8),
        _widgetEditableUserName(_user),
        SizedBox(height: 16),
        Text('Контакты:', style: appTheme.textTheme.subtitle1, textAlign: TextAlign.center),
        _allUsers.length > 0 ? Container() : _widgetStubContact()
      ],
    );
  }

  Center _widgetUsersList() {
    return Center(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _allUsers.length,
              itemBuilder: (context, index) => _widgetUserContact(_allUsers[index]),
            ),);
  }

  Widget _widgetEditableUserName(User user) {
    return InkWell(
      onTap: () => UiUtils.dialogEditText(context, _user.name)
          .then((result) {
            if (result != null) {
              setState(() => _user.name = result);
              return firestore.rename(_user)
                  .then((_) => wss.sendMessage('user remove', _user.id))
                  .then((_) => wss.sendMessage('user add', {'name': user.name, 'type': 'mobile'}));
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(children: <Widget>[
                AvatarWidget(user.name, 48),
                SizedBox(width: 16),
                Text('${user.name}', style: appTheme.textTheme.headline2),
                Expanded(
                  child: Text('[${user.token == null ? 'wss' : 'push'}]', textAlign: TextAlign.end,
                      style: appTheme.textTheme.headline2),
                )
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
    return UiUtils.widgetCircleButton(56, colorAccent,
      'assets/icons/ic_refresh.png', 2.2, Colors.white,
      () => refresh());
  }

}
